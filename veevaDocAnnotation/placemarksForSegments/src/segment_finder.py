import fitz  # PyMuPDF
import logging
import re
from typing import List, Dict, Any

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def is_sentence_boundary(text: str) -> bool:
    """Check if text ends with sentence boundary punctuation."""
    sentence_endings = ['.', '!', '?', ':', ';']
    return any(text.strip().endswith(p) for p in sentence_endings)

def is_title_or_heading(text: str, font_size: float, avg_font_size: float) -> bool:
    """Check if text is likely a title or heading based on font size."""
    return font_size > avg_font_size * 1.2  # 20% larger than average

def split_into_segments(text: str) -> List[str]:
    """Split text into segments based on punctuation and formatting."""
    # Split on sentence endings followed by space or newline
    segments = re.split(r'([.!?:;][\s\n])', text)
    
    # Recombine segments with their punctuation
    result = []
    for i in range(0, len(segments)-1, 2):
        if i+1 < len(segments):
            result.append(segments[i] + segments[i+1].strip())
        else:
            result.append(segments[i])
    
    # Add any remaining text
    if segments and len(segments) % 2 == 1:
        last_segment = segments[-1].strip()
        if last_segment:
            result.append(last_segment)
    
    return [s.strip() for s in result if s.strip()]

def find_segment_coordinates(pdf_path: str, segments: List[str] = None) -> List[Dict[str, Any]]:
    """
    Find coordinates of segments in a PDF document.
    If segments list is provided, find those specific segments.
    If no segments provided, extract natural segments from the document.
    """
    try:
        doc = fitz.open(pdf_path)
        results = []
        found_segments = set()
        
        # Calculate average font size across document
        total_font_size = 0
        total_spans = 0
        for page in doc:
            blocks = page.get_text("dict")["blocks"]
            for block in blocks:
                for line in block.get("lines", []):
                    for span in line.get("spans", []):
                        total_font_size += span.get("size", 0)
                        total_spans += 1
        
        avg_font_size = total_font_size / total_spans if total_spans > 0 else 0
        
        # Process each page
        for page_number, page in enumerate(doc, start=1):
            blocks = page.get_text("dict")["blocks"]
            for block in blocks:
                current_text = ""
                current_rect = None
                
                for line in block.get("lines", []):
                    line_text = ""
                    line_spans = []
                    
                    # Collect text and font information from spans
                    for span in line.get("spans", []):
                        span_text = span.get("text", "").strip()
                        if span_text:
                            line_text += span_text + " "
                            line_spans.append({
                                "text": span_text,
                                "font_size": span.get("size", 0),
                                "bbox": span.get("bbox")
                            })
                    
                    line_text = line_text.strip()
                    if not line_text:
                        continue
                    
                    # Handle titles and headings
                    if line_spans and is_title_or_heading(line_text, line_spans[0]["font_size"], avg_font_size):
                        if current_text:
                            # Process accumulated text before handling heading
                            for segment in split_into_segments(current_text):
                                results.append({
                                    "segment": segment,
                                    "page_number": page_number,
                                    "x": current_rect[0],
                                    "y": current_rect[1],
                                    "width": current_rect[2] - current_rect[0],
                                    "height": current_rect[3] - current_rect[1],
                                    "coordinates": [
                                        current_rect[0], current_rect[1],
                                        current_rect[2], current_rect[1],
                                        current_rect[0], current_rect[3],
                                        current_rect[2], current_rect[3]
                                    ]
                                })
                            current_text = ""
                        
                        # Add heading as a segment
                        bbox = line_spans[0]["bbox"]
                        results.append({
                            "segment": line_text,
                            "page_number": page_number,
                            "x": bbox[0],
                            "y": bbox[1],
                            "width": bbox[2] - bbox[0],
                            "height": bbox[3] - bbox[1],
                            "coordinates": [
                                bbox[0], bbox[1],
                                bbox[2], bbox[1],
                                bbox[0], bbox[3],
                                bbox[2], bbox[3]
                            ]
                        })
                        continue
                    
                    # Accumulate text and update bounding box
                    if current_text:
                        current_text += " "
                    current_text += line_text
                    
                    if current_rect is None:
                        current_rect = list(line["bbox"])
                    else:
                        current_rect[2] = max(current_rect[2], line["bbox"][2])
                        current_rect[3] = max(current_rect[3], line["bbox"][3])
                    
                    # Check for sentence boundaries
                    if is_sentence_boundary(line_text):
                        for segment in split_into_segments(current_text):
                            results.append({
                                "segment": segment,
                                "page_number": page_number,
                                "x": current_rect[0],
                                "y": current_rect[1],
                                "width": current_rect[2] - current_rect[0],
                                "height": current_rect[3] - current_rect[1],
                                "coordinates": [
                                    current_rect[0], current_rect[1],
                                    current_rect[2], current_rect[1],
                                    current_rect[0], current_rect[3],
                                    current_rect[2], current_rect[3]
                                ]
                            })
                        current_text = ""
                        current_rect = None
                
                # Handle any remaining text in the block
                if current_text:
                    for segment in split_into_segments(current_text):
                        results.append({
                            "segment": segment,
                            "page_number": page_number,
                            "x": current_rect[0],
                            "y": current_rect[1],
                            "width": current_rect[2] - current_rect[0],
                            "height": current_rect[3] - current_rect[1],
                            "coordinates": [
                                current_rect[0], current_rect[1],
                                current_rect[2], current_rect[1],
                                current_rect[0], current_rect[3],
                                current_rect[2], current_rect[3]
                            ]
                        })
        
        # If specific segments were requested, filter results
        if segments:
            filtered_results = []
            for segment in segments:
                for result in results:
                    if segment in result["segment"] and segment not in found_segments:
                        filtered_results.append(result)
                        found_segments.add(segment)
                        logger.info(f"Found segment '{segment}' on page {result['page_number']}")
            return filtered_results
        
        return results

    except Exception as e:
        logger.error(f"Error processing PDF: {str(e)}")
        raise 