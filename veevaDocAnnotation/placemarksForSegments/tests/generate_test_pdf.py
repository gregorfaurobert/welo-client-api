import os
import fitz

def generate_test_pdf():
    # Create test_data directory if it doesn't exist
    os.makedirs("test_data", exist_ok=True)
    
    # Create a new PDF document
    doc = fitz.open()
    
    # Add a page
    page = doc.new_page()
    
    # Add some text with known segments
    text = """
    This is a test PDF document.
    Welcome to the system.
    Please read the instructions carefully.
    This is another test segment.
    """
    
    # Insert the text
    page.insert_text((50, 50), text)
    
    # Save the PDF
    output_path = os.path.join("test_data", "sample.pdf")
    doc.save(output_path)
    doc.close()
    print(f"Test PDF generated at: {output_path}")

if __name__ == "__main__":
    generate_test_pdf() 