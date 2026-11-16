import http.server
import socketserver
import webbrowser
import os
import sys

PORT = 8080
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

def run():
    os.chdir(DIRECTORY)
    try:
        with socketserver.TCPServer(("", PORT), Handler) as httpd:
            url = f"http://localhost:{PORT}/index.html"
            print("=" * 65)
            print(f"boAt PB331 + Galaxy S25 Dock Customizer Webapp (v1.2.0)")
            print(f"Server running at: {url}")
            print("Opening webapp in default browser...")
            print("Press Ctrl+C to stop the server.")
            print("=" * 65)
            webbrowser.open(url)
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")
    except Exception as e:
        print(f"Error starting server: {e}")
        # Fallback to direct file open
        file_url = f"file:///{DIRECTORY}/index.html"
        print(f"Opening directly in browser: {file_url}")
        webbrowser.open(file_url)

if __name__ == '__main__':
    run()
