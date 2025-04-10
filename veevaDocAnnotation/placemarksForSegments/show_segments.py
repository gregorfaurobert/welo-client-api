import json
import os

def show_segments():
    # Load the JSON file
    json_path = os.path.join('tests', 'test_data', 'segment_positions.json')
    with open(json_path, 'r') as f:
        data = json.load(f)
    
    print("\nAutomatically detected segments (first 20):")
    print("=" * 80)
    
    # Group segments by page
    segments_by_page = {}
    for segment in data['segments']:
        page = segment['page']
        if page not in segments_by_page:
            segments_by_page[page] = []
        segments_by_page[page].append(segment)
    
    # Show first few segments from each page
    for page in sorted(segments_by_page.keys()):
        print(f"\nPage {page}:")
        print("-" * 40)
        segments = segments_by_page[page][:5]  # Show first 5 segments per page
        for segment in segments:
            print(f"• {segment['text']}")
    
    print(f"\nTotal segments found: {len(data['segments'])}")

if __name__ == "__main__":
    show_segments() 