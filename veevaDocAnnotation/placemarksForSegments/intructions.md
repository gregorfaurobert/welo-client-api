Awesome! Here's a **step-by-step TODO plan** for your AI agent (e.g. Cursor AI) to build a **local proof-of-concept (POC)** that takes a PDF and a list of segments, and returns the coordinates for each segment using `PyMuPDF` (aka `fitz`).

---

## ✅ Goal

Create a script or microservice that:
- Accepts a **PDF file** and a list of **text segments**
- Returns the **coordinates (bounding box)** of each segment if found in the PDF

---

## 🧭 Project Plan (POC Level)

### 1. 📦 Setup Project
- [ ] Create a new Python project (can be just one `.py` file to start)
- [ ] Add a `requirements.txt` file with:
  ```txt
  pymupdf
  flask  # (optional, if you want to expose it as a local API)
  ```

- [ ] Install dependencies:
  ```bash
  pip install -r requirements.txt
  ```

---

### 2. 📄 Prepare Sample PDF and Segment List
- [ ] Save a **sample PDF** in the project folder (e.g. `sample.pdf`)
- [ ] Create a list of segments to search for (can be hardcoded or loaded from a JSON/text file)

---

### 3. 🧠 Core Logic: PDF Segment Matching
- [ ] Use `fitz` to open the PDF
- [ ] Loop over pages
- [ ] Extract text lines with bounding boxes
- [ ] Match each line to a segment
- [ ] If a match is found, save page number and coordinates

#### Sample function structure:

```python
import fitz  # PyMuPDF

def find_segment_coordinates(pdf_path, segments):
    doc = fitz.open(pdf_path)
    results = []
    found_segments = set()

    for page_number, page in enumerate(doc, start=1):
        blocks = page.get_text("dict")["blocks"]
        for block in blocks:
            for line in block.get("lines", []):
                line_text = " ".join(span["text"] for span in line["spans"]).strip()
                for segment in segments:
                    if segment in line_text and segment not in found_segments:
                        rect = fitz.Rect(line["bbox"])
                        x0, y0, x1, y1 = rect.x0, rect.y0, rect.x1, rect.y1
                        results.append({
                            "segment": segment,
                            "page_number": page_number,
                            "x": x0,
                            "y": y0,
                            "width": x1 - x0,
                            "height": y1 - y0,
                            "coordinates": [x0, y0, x1, y0, x0, y1, x1, y1]
                        })
                        found_segments.add(segment)

    return results
```

---

### 4. 🧪 Test the Function
- [ ] Write a simple test file like this:

```python
if __name__ == "__main__":
    segments = [
        "Welcome to the system.",
        "Please read the instructions."
    ]
    results = find_segment_coordinates("sample.pdf", segments)
    for r in results:
        print(r)
```

---

### 5. (Optional) 🌐 Add Local Flask API
If you want to test it with HTTP requests (for future Lambda use):

- [ ] Add a `Flask` server:

```python
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/segments", methods=["POST"])
def get_segments():
    data = request.json
    pdf_path = data["pdf_path"]  # Or base64, for next phase
    segments = data["segments"]
    results = find_segment_coordinates(pdf_path, segments)
    return jsonify(results)

if __name__ == "__main__":
    app.run(debug=True)
```
