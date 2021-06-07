package main

import (
	"flag"
	"io/fs"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"
)

func createChecksumFile() {
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

		log.Print(path)

		return nil
	})
	if err != nil {
		log.Fatal(err)
	}
}

func createTimestampFile() {
	name := time.Now().UTC().Format(time.RFC3339) + ".txt"
	if err := os.WriteFile(name, nil, 0o644); err != nil {
		log.Fatal(err)
	}
}

func main() {
	log.SetPrefix("tipper: ")
	log.SetFlags(log.Lmsgprefix)

	checksumF := flag.Bool("checksum", false, "create checksum file")
	timestampF := flag.Bool("timestamp", false, "create timestamp file")

	flag.Parse()

	if *checksumF {
		createChecksumFile()
	}

	if *timestampF {
		createTimestampFile()
	}
}
