# Simulation of MagSafe Ring Alignment: boAt PB331 vs Samsung Galaxy S25

# Galaxy S25 + Silicone MagSafe Case
phone_h = 150.5 # mm total height
phone_ring_from_bottom = 74.0 # mm (center of MagSafe ring from bottom edge of cased phone)
phone_ring_from_top = phone_h - phone_ring_from_bottom # 76.5 mm
phone_camera_bump_bottom_from_top = 43.0 # mm (camera island extends 43mm down from top)

# boAt EnergyShroom PB331
pb_h = 108.0 # mm
pb_ring_from_top = 30.5 # mm (from photo: ring center is 30.5mm from top edge)
pb_ring_from_bottom = pb_h - pb_ring_from_top # 77.5 mm

print("=" * 65)
print("MAGSAFE RING CONCENTRIC ALIGNMENT & CAMERA CLEARANCE SIMULATION")
print("=" * 65)
print(f"Phone Ring Center: {phone_ring_from_bottom:.1f} mm from bottom | {phone_ring_from_top:.1f} mm from top")
print(f"PB331 Ring Center: {pb_ring_from_bottom:.1f} mm from bottom | {pb_ring_from_top:.1f} mm from top")
print(f"Camera Island Extent: Top 0.0 mm to {phone_camera_bump_bottom_from_top:.1f} mm")
print("-" * 65)
print(f"{'rim_below_top':>14} | {'ledge_y':>8} | {'Ring Offset':>12} | {'Camera Air Gap':>15} | Status")
print("-" * 65)

for rim in [38.0, 40.0, 42.0, 44.0, 45.0, 46.0, 47.0, 48.0, 50.0]:
    ledge_y = (pb_h + 0.8) + rim - phone_h
    # Phone rests on ledge_y
    # Phone ring center in dock frame: ledge_y + phone_ring_from_bottom
    phone_ring_dock_y = ledge_y + phone_ring_from_bottom
    pb_ring_dock_y = pb_ring_from_bottom # 77.5 mm
    offset = phone_ring_dock_y - pb_ring_dock_y
    camera_clearance = rim - phone_camera_bump_bottom_from_top
    status = "PERFECT ALIGNMENT" if abs(offset) < 1.0 else ("EXCELLENT (<3mm)" if abs(offset) < 3.0 else "GOOD")
    if camera_clearance < 0:
        status += " [CAMERA COLLISION!]"
    print(f"{rim:12.1f} mm | {ledge_y:6.1f} mm | {offset:10.1f} mm | {camera_clearance:13.1f} mm | {status}")
print("=" * 65)
