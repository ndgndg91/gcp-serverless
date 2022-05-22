package functions

import (
	"encoding/json"
	"fmt"
	"html"
	"io"
	"log"
	"net/http"
)

// HelloHTTP is an HTTP Cloud Function with a request parameter.
func HelloHTTP(w http.ResponseWriter, r *http.Request) {
	b, err := io.ReadAll(r.Body)
	if err != nil {
		log.Fatalln(err)
	}

	reqString := string(b)
	fmt.Println(reqString)
	if reqString == "" {
		_, _ = fmt.Fprintf(w, "Hello Empty Request Body")
		return
	}

	_, _ = fmt.Fprintf(w, "%s", reqString)
}

func parseName(w http.ResponseWriter, r *http.Request) {
	var d struct {
		Name string `json:"name"`
	}

	if err := json.NewDecoder(r.Body).Decode(&d); err != nil {
		_, _ = fmt.Fprint(w, "Hello, World!")
		return
	}

	if d.Name == "" {
		_, _ = fmt.Fprint(w, "Hello, World!")
		return
	}
	_, _ = fmt.Fprintf(w, "Hello, %s!", html.EscapeString(d.Name))
}
