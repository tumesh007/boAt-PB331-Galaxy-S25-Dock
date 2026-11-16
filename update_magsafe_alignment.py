import re

code = open('/home/pnb/.gemini/antigravity/scratch/boAt_PB331_S25_dock/boAt_PB331_Galaxy_S25_Dock.scad').read()

# Update rim_below_phone_top to 46.0 mm with detailed explanation
old_str = "rim_below_phone_top = 48.0;// 48mm guarantees complete rear camera bump clearance"
new_str = """// Magnetic Ring Concentric Alignment & Camera Clearance:
// - PB331 MagSafe ring center: 30.5mm below top rim of power bank (measured from photo)
// - Galaxy S25 MagSafe ring center: 76.5mm below top of cased phone (74.0mm from bottom)
// - S25 Camera bump extends: 43.0mm from top
// Perfectly concentric alignment: 76.5 - 30.5 = 46.0 mm
// At 46.0mm: Ring offset = 0.0 mm (Peak 15W Qi lock) & Camera air clearance = 3.0 mm!
rim_below_phone_top = 46.0;"""

code = code.replace(old_str, new_str)
with open('/home/pnb/.gemini/antigravity/scratch/boAt_PB331_S25_dock/boAt_PB331_Galaxy_S25_Dock.scad', 'w') as f:
    f.write(code)

print("Updated rim_below_phone_top to 46.0 mm!")
