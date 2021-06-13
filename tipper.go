package main

import (
	"crypto/sha256"
	"flag"
	"fmt"
	"io"
	"io/fs"
	"log"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"sync"
	"time"
)

const (
	checksumFileName = "sha256.txt"
)

func checksumFile(path string) (string, error) {
	f, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer f.Close()

	h := sha256.New()
	if _, err = io.Copy(h, f); err != nil {
		return "", err
	}

	return fmt.Sprintf("%064x", h.Sum(nil)), nil
}

func createChecksumFile() {
	paths := make(chan string)
	lines := make(chan string)

	go func() {
		err := filepath.Walk(".", func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if info.IsDir() {
				if path == ".git" {
					return filepath.SkipDir
				}
				return nil
			}

			if !strings.HasSuffix(path, ".tar.gz") {
				return nil
			}

			paths <- path
			return nil
		})
		if err != nil {
			log.Fatal(err)
		}
		close(paths)
	}()

	var wg sync.WaitGroup
	for i := 0; i < runtime.GOMAXPROCS(-1); i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()

			for path := range paths {
				checksum, err := checksumFile(path)
				if err != nil {
					log.Fatal(err)
				}
				lines <- fmt.Sprintf("%s  %s", checksum, path)
			}
		}()
	}

	go func() {
		wg.Wait()
		close(lines)
	}()

	f, err := os.Create(checksumFileName)
	if err != nil {
		log.Fatal(err)
	}
	for line := range lines {
		if _, err = f.WriteString(line + "\n"); err != nil {
			log.Fatal(err)
		}
	}
	if err = f.Close(); err != nil {
		log.Fatal(err)
	}

	log.Printf("%s created.", checksumFileName)
}

func createTimestampFile() {
	name := fmt.Sprintf("Built on %s.txt", time.Now().UTC().Format(time.RFC3339))
	if err := os.WriteFile(name, nil, 0o644); err != nil {
		log.Fatal(err)
	}

	log.Printf("%q created.", name)
}

func main() {
	log.SetPrefix("tipper: ")
	log.SetFlags(log.Lmsgprefix)

	flag.Parse()

	for _, cmd := range flag.Args() {
		switch cmd {
		case "checksum":
			createChecksumFile()
		case "timestamp":
			createTimestampFile()
		default:
			log.Fatalf("Unhandled command %q.", cmd)
		}
	}
}
