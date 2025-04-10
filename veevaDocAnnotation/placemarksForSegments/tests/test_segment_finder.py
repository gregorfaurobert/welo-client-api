import pytest
import os
from src.segment_finder import find_segment_coordinates

def test_find_segment_coordinates():
    # Path to the sample PDF
    pdf_path = os.path.join(os.path.dirname(__file__), "test_data", "sample.pdf")
    
    # Test segments that we know exist in the PDF
    segments = [
        "Welcome to the system",
        "Please read the instructions carefully",
        "This is another test segment"
    ]
    
    # Run the segment finder
    results = find_segment_coordinates(pdf_path, segments)
    
    # Basic validation
    assert isinstance(results, list)
    assert len(results) == len(segments), "Should find all segments"
    
    # Validate each result
    for result in results:
        assert "segment" in result
        assert "page_number" in result
        assert "x" in result
        assert "y" in result
        assert "width" in result
        assert "height" in result
        assert "coordinates" in result
        assert len(result["coordinates"]) == 8, "Should have 8 coordinates (4 points)"
        
        # Verify the segment was found
        assert result["segment"] in segments, f"Found unexpected segment: {result['segment']}"
        
        # Verify coordinates are valid
        assert result["width"] > 0, "Width should be positive"
        assert result["height"] > 0, "Height should be positive"
        assert result["x"] >= 0, "X coordinate should be non-negative"
        assert result["y"] >= 0, "Y coordinate should be non-negative" 