import fitz
import os

def analyze_pdf(pdf_path):
    # Open the PDF
    doc = fitz.open(pdf_path)
    
    print("\nAnalyzing PDF content...")
    print("=" * 50)
    
    # Get text from each page
    for page_num, page in enumerate(doc, start=1):
        print(f"\nPage {page_num}:")
        print("-" * 20)
        
        # Get text blocks
        blocks = page.get_text("dict")["blocks"]
        for block in blocks:
            for line in block.get("lines", []):
                # Join spans to get complete line text
                line_text = " ".join(span["text"] for span in line["spans"]).strip()
                if line_text:  # Only print non-empty lines
                    print(f"Found text: '{line_text}'")
    
    doc.close()

if __name__ == "__main__":
    pdf_path = os.path.join("tests", "test_data", "sample.pdf")
    analyze_pdf(pdf_path) 