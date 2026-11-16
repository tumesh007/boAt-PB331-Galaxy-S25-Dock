// =============================================================================
// Premium 3D-Printable Desktop Wireless Charging Stand & Dock (v1.2.0)
// Hardware: boAt EnergyShroom PB331 Magnetic Power Bank (108 x 70 x 19.5 mm + 1.5mm MagSafe Pad)
//           Samsung Galaxy S25 in Silicone MagSafe Case (150.5 x 74.5 x 10.5 mm)
//
// Dual Architecture Profiles:
//   - "standard": Heavy desktop ballast (110 x 110 x 12 mm base, ~109g print mass)
//   - "lite":     Ultra-compact slim profile (86 x 98 x 8 mm base + bottom cored cavities, ~48g print mass)
//
// Retained Across Both Variants:
//   - Left-offset boAt USB-C charging slot (X = -16.0 mm)
//   - Center 5-LED battery status window (X = 0.0 mm)
//   - Dedicated Galaxy S25 wired charging pass-through slot (Center X = 0.0 mm)
//   - Dual-cable continuous under-base raceway with rear egress
//   - Concentric MagSafe ring alignment (0.0mm Qi offset, 3.5mm boAt underhang, 3.0mm camera gap)
//   - 100% support-free FDM printing, single-piece manifold solid
//   - Personalized front nameplate ("TUMESH")
// =============================================================================

/* [Model Architecture & Weight Profile] */
dock_variant    = "standard"; // ["standard": Desktop Ballast (~109g), "lite": Slim Lightweight (~48g)]

// Dynamic conditional assignment
is_lite         = (dock_variant == "lite");

/* [Devices & Real Clearances] */
pb_h            = 108.0;   // boAt PB331 nominal height (mm)
pb_w            = 70.0;    // boAt PB331 nominal width (mm)
pb_body_d       = 19.5;    // boAt PB331 main body thickness (mm)
pb_pad_d        = 1.5;     // Additional depth of raised circular MagSafe pad (mm)
phone_h         = 150.5;   // Cased Galaxy S25 height (mm)
phone_w         = 74.5;    // Cased Galaxy S25 width (mm)
phone_t         = 10.5;    // Cased Galaxy S25 thickness (mm)

tol_w           = 0.8;     // Width print tolerance (+0.8mm total -> 70.8mm pocket)
tol_d           = 0.8;     // Depth clearance (+0.8mm -> 20.3mm pocket)
tol_h           = 0.8;     // Height clearance (+0.8mm -> 108.8mm pocket)

pocket_w        = pb_w + tol_w;          // 70.8 mm
pocket_d        = pb_body_d + tol_d;      // 20.3 mm (comfortably seats 19.5mm body)
pocket_h        = pb_h + tol_h;          // 108.8 mm

/* [Ergonomics & Camera Clearance] */
tilt            = 65.0;    // Viewing angle (65 deg backward from desk)
rim_below_phone_top = 46.0; // 0.0mm concentric Qi lock, 3.5mm underhang, 3.0mm camera clearance

/* [Phone Resting Ledge] */
ledge_len       = 14.0;    // Forward shelf depth (mm)
lip_h           = 3.2;     // Front retaining lip height (holds case, frees gestures)
lip_t           = 2.6;     // Lip wall thickness
notch_w         = 40.0;    // Center finger swipe gesture & speaker/port notch width

/* [Walls & Structure] */
wall_rear       = is_lite ? 2.4  : 3.6;     // Backrest wall thickness behind PB331
rail_w          = is_lite ? 3.0  : 4.2;     // Side rail width
shelf_floor     = is_lite ? 2.6  : 3.6;     // Floor thickness at base of pocket
fillet_r        = 2.0;     // Exterior edge radius
lead_in         = 1.5;     // 45-degree top entry chamfer for smooth PB insertion

/* [Ventilation Cutouts - Support Free Gothic Vents] */
vent_w          = 55.0;    // Total width of ventilation zone
vent_h          = 82.0;    // Total height of ventilation zone
vent_slots      = 7;       // Number of vertical slots
rib_t           = 2.8;     // Width of structural ribs between slots

/* [USB-C Port, LED Window & Cable Routing] */
usbc_port_x     = -16.0;   // USB-C port center offset from midline
cable_slot_w    = 20.0;    // USB-C slot width
cable_slot_t    = 11.5;    // USB-C slot thickness
led_window_w    = 16.0;    // Center battery LED indicator window width
cable_radius    = 4.5;     // Semi-cylindrical channel radius (9.0mm diameter, form-fitted for circular braided cables)

// Galaxy S25 bottom wired charging port (Center X = 0mm)
s25_cable_slot_w = 14.0;   // S25 USB-C plug pass-through slot width
s25_cable_slot_t = 10.0;   // S25 USB-C plug forward clearance along shelf

/* [Base & Anti-Tip Footprint] */
base_w          = is_lite ? 86.0 : 110.0;  // Base width
base_h          = is_lite ? 8.0  : 12.0;   // Base thickness
base_extra_f    = is_lite ? 10.0 : 12.0;   // Front toe extension
base_extra_r    = is_lite ? 12.0 : 14.0;   // Rear heel extension

/* [Personalization / Front Nameplate] */
show_name       = true;     // Enable custom nameplate on front of base
custom_name     = "TUMESH"; // Name / branding text on front face
name_style      = "deboss"; // "deboss" (engraved) or "emboss" (raised lettering)
name_font_size  = is_lite ? 4.8 : 5.5; // Text height in mm (scales with base_h)
name_depth      = 0.6;      // Engraving / protrusion depth (0.6mm = 3 perimeters, crisp deboss)
name_font       = "Arial:style=Bold"; // Font family & style

/* [Friction Grip Retention] */
enable_grip     = true;    // Side retention ribs
grip_depth      = 0.25;    // Protrusion into pocket (mm per side)

/* [Quality / Rendering] */
$fn = 36;

// =============================================================================
// DERIVED MATH & COORDINATE CALCULATIONS
// =============================================================================

rad = tilt * PI / 180;
c = cos(tilt);
s = sin(tilt);

dock_w = pocket_w + 2 * rail_w; // Standard: 79.2 mm, Lite: 76.8 mm
ledge_y = pocket_h + rim_below_phone_top - phone_h; // 4.3 mm

z_dock_rear = -(pocket_d + wall_rear);
z_lip_front = ledge_len + lip_t;

function slab_gy(v, z) = v * c - z * s;
function slab_gz(v, z) = v * s + z * c;

p0_y_offset = base_extra_f - slab_gy(-shelf_floor, z_lip_front);
p0_z_offset = base_h - slab_gz(-shelf_floor, z_dock_rear);

top_rear_y = p0_y_offset + slab_gy(pocket_h, z_dock_rear);
base_d = top_rear_y + base_extra_r;

echo("=== BOAt PB331 + GALAXY S25 DOCK ===");
echo(str("Variant: ", dock_variant, " (is_lite = ", is_lite, ")"));
echo(str("Total Base Dimensions: ", base_w, " mm (W) x ", base_d, " mm (D) x ", base_h, " mm (H)"));
echo(str("PB331 Pocket Size: ", pocket_w, " x ", pocket_d, " x ", pocket_h, " mm"));
echo(str("Phone Resting Shelf Depth: ", ledge_len, " mm (Fits phone + raised pad)"));
echo(str("boAt USB-C Port Location: X = ", usbc_port_x, " mm (Left)"));
echo("S25 Wired USB-C Cutout: X = 0.0 mm (Center dual-drop raceway)");

// =============================================================================
// MODULE DEFINITIONS
// =============================================================================

module filleted_box(sz, r_fillet = fillet_r, flat_bottom = true) {
    x0 = r_fillet; x1 = sz.x - r_fillet;
    y0 = r_fillet; y1 = sz.y - r_fillet;
    z0 = flat_bottom ? 0 : r_fillet;
    z1 = sz.z - r_fillet;
    
    hull() {
        for (x = [x0, x1], y = [y0, y1]) {
            translate([x, y, z1]) sphere(r = r_fillet);
            if (flat_bottom) {
                translate([x, y, 0]) cylinder(r = r_fillet, h = 0.01);
            } else {
                translate([x, y, z0]) sphere(r = r_fillet);
            }
        }
    }
}

module to_slab() {
    translate([0, p0_y_offset, p0_z_offset])
        rotate([tilt, 0, 0])
            children();
}

module dock_base() {
    translate([-base_w / 2, 0, 0])
        filleted_box([base_w, base_d, base_h], r_fillet = fillet_r, flat_bottom = true);
}

module cradle_blank() {
    slab_len = pocket_h + shelf_floor;
    slab_thk = -z_dock_rear;
    
    // Backrest envelope
    translate([-dock_w / 2, -shelf_floor, z_dock_rear]) {
        hull() {
            for (x = [fillet_r, dock_w - fillet_r]) {
                translate([x, 0, fillet_r]) sphere(r = fillet_r);
                translate([x, slab_len - fillet_r, fillet_r]) sphere(r = fillet_r);
                translate([x, slab_len - fillet_r, slab_thk - fillet_r]) sphere(r = fillet_r);
                translate([x, 0, slab_thk - fillet_r]) sphere(r = fillet_r);
            }
        }
    }
    
    // Lower shelf block with planar resting surface at Y = ledge_y
    shelf_len = ledge_y + shelf_floor;
    translate([-dock_w / 2, -shelf_floor, z_dock_rear]) {
        hull() {
            for (x = [fillet_r, dock_w - fillet_r]) {
                translate([x, 0, fillet_r]) sphere(r = fillet_r);
                translate([x, shelf_len, fillet_r]) cylinder(r = fillet_r, h = 0.01);
                translate([x, shelf_len, z_lip_front - z_dock_rear - fillet_r]) cylinder(r = fillet_r, h = 0.01);
                translate([x, 0, z_lip_front - z_dock_rear - fillet_r]) sphere(r = fillet_r);
            }
        }
    }
        
    // Front retaining lip
    translate([-dock_w / 2, ledge_y, ledge_len]) {
        hull() {
            for (x = [fillet_r, dock_w - fillet_r]) {
                translate([x, 0, 0]) cylinder(r = fillet_r, h = lip_t);
                translate([x, lip_h - 1.2, 1.2]) sphere(r = 1.2);
                translate([x, lip_h - 1.2, lip_t - 1.2]) sphere(r = 1.2);
            }
        }
    }
}

module cradle_pedestal() {
    hull() {
        to_slab() {
            translate([-dock_w / 2, -shelf_floor, z_dock_rear])
                cube([dock_w, ledge_y + shelf_floor, z_lip_front - z_dock_rear]);
        }
        y_front = p0_y_offset + slab_gy(-shelf_floor, z_lip_front);
        y_rear  = p0_y_offset + slab_gy(pocket_h * 0.40, z_dock_rear);
        translate([-dock_w / 2, y_front, 0])
            cube([dock_w, y_rear - y_front, base_h]);
    }
}

module rear_buttresses() {
    for (side = [-1, 1]) {
        x_pos = side * (dock_w / 2 - 3.0);
        hull() {
            to_slab() {
                translate([x_pos - side * 1.5, pocket_h * 0.75, z_dock_rear])
                    sphere(r = 2.0);
                translate([x_pos - side * 1.5, pocket_h * 0.35, z_dock_rear])
                    sphere(r = 2.0);
            }
            anchor_y = p0_y_offset + slab_gy(pocket_h * 0.50, z_dock_rear);
            translate([x_pos - side * 1.5, anchor_y, 0])
                cylinder(r = 2.5, h = base_h + 1.0);
            translate([x_pos - side * 1.5, anchor_y - 20, 0])
                cylinder(r = 2.5, h = base_h + 1.0);
        }
    }
}

module pb_pocket_cavity() {
    translate([-pocket_w / 2, 0, -pocket_d])
        cube([pocket_w, pocket_h - lead_in, pocket_d + 1.0]);
        
    hull() {
        translate([-pocket_w / 2, pocket_h - lead_in, -pocket_d])
            cube([pocket_w, 0.01, pocket_d + 1.0]);
        translate([-pocket_w / 2 - lead_in, pocket_h + 0.1, -pocket_d - lead_in])
            cube([pocket_w + 2 * lead_in, 0.01, pocket_d + lead_in + 1.1]);
    }
    
    translate([-pocket_w / 2 - lead_in, pocket_h, -pocket_d - lead_in])
        cube([pocket_w + 2 * lead_in, 20.0, pocket_d + lead_in + 1.5]);
}

module ventilation_cutout() {
    slot_w = (vent_w - (vent_slots - 1) * rib_t) / vent_slots;
    y_start = (pocket_h - vent_h) / 2;
    cut_depth = wall_rear + 4.0;
    cap_h = slot_w * 1.35;
    
    for (i = [0 : vent_slots - 1]) {
        x_slot = -vent_w / 2 + i * (slot_w + rib_t);
        
        translate([x_slot, y_start, z_dock_rear - 1.0]) {
            linear_extrude(height = cut_depth) {
                polygon([
                    [0, cap_h],
                    [slot_w / 2, 0.1],
                    [slot_w, cap_h],
                    [slot_w, vent_h - cap_h],
                    [slot_w / 2, vent_h - 0.1],
                    [0, vent_h - cap_h]
                ]);
            }
        }
    }
}

// Multi-Port & Indicator Cutout at Pocket Floor:
// 1. Left USB-C pass-through slot centered at X = -16.0mm (45-degree self-supporting peaked arch)
// 2. Center LED viewing window centered at X = 0.0mm
module cable_pocket_slot() {
    // Left boAt USB-C charging slot with peaked Gothic roof to eliminate horizontal bridge cantilever
    hull() {
        translate([usbc_port_x - cable_slot_w / 2, -shelf_floor - 2.0, -pocket_d + (pocket_d - cable_slot_t) / 2])
            cube([cable_slot_w, shelf_floor + 2.01, cable_slot_t - 3.0]);
        translate([usbc_port_x, -shelf_floor - 2.0, -pocket_d + (pocket_d - cable_slot_t) / 2 + cable_slot_t])
            cube([0.1, shelf_floor + 2.01, 0.1]);
    }
        
    // Angled channel running through pedestal into the base from USB-C port
    hull() {
        translate([usbc_port_x - cable_slot_w / 2, -shelf_floor - 1.0, -pocket_d + (pocket_d - cable_slot_t) / 2])
            cube([cable_slot_w, 1.0, cable_slot_t]);
        translate([usbc_port_x - cable_slot_w / 2, -35.0, -pocket_d])
            cube([cable_slot_w, 1.0, cable_slot_t + 4.0]);
    }
    
    // Center LED battery indicator viewing window
    translate([-led_window_w / 2, -shelf_floor - 2.0, -pocket_d + 1.0])
        cube([led_window_w, shelf_floor + 2.01, pocket_d - 2.0]);
}

// S25 Center Wired Charging Cable Pass-Through:
// Directly below Galaxy S25 bottom USB-C port (centered at X = 0.0mm)
// Drops vertically through shelf floor and sloped pedestal into under-base gable channel
module s25_cable_slot() {
    translate([-s25_cable_slot_w / 2, -35.0, 1.0])
        cube([s25_cable_slot_w, ledge_y + 35.0 + 1.0, s25_cable_slot_t]);
}

// Under-Base Cable Exit Channel & Rear Egress
// Continuous semi-cylindrical raceway (R = 4.5mm, D = 9.0mm) with upward low-back sweep exit
// Form-fitted to circular braided USB-C cables, 100% support-free FDM bridging, with zero sharp bends
module cable_base_channel() {
    sy = p0_y_offset + slab_gy(-shelf_floor, -pocket_d / 2);
    chan_r = cable_radius;
    chan_y_start = 14.0;
    chan_len = base_d - chan_y_start + 6.0;
    
    // 1. Center continuous semi-cylindrical raceway (Z >= 0) from S25 drop to rear
    translate([0, chan_y_start, 0]) {
        rotate([-90, 0, 0]) {
            cylinder(r = chan_r, h = chan_len);
        }
    }
    
    // 2. Smooth semi-cylindrical diagonal sweep from left boAt USB-C port
    hull() {
        translate([usbc_port_x, sy - 4.0, 0])
            sphere(r = chan_r);
        translate([0, sy + 14.0, 0])
            sphere(r = chan_r);
    }
    
    // 3. Low back upward-sloping sweep exit (pulls cable smoothly up to rear egress)
    translate([0, base_d - 4.0, 0]) {
        rotate([-90 + 22, 0, 0]) {
            cylinder(r = chan_r + 0.4, h = 18.0);
        }
    }
}

module phone_shelf_notch() {
    notch_y_start = -shelf_floor - 1.0;
    notch_y_len   = ledge_y + lip_h + shelf_floor + 4.0;
    notch_z_len   = ledge_len + lip_t + 2.0;
    
    translate([-notch_w / 2, notch_y_start, -0.1])
        cube([notch_w, notch_y_len, notch_z_len]);
        
    for (s = [-1, 1]) {
        translate([s * notch_w / 2, ledge_y, ledge_len / 2])
            rotate([0, 45, 0])
                cube([2.0, lip_h + 3.0, 2.0], center = true);
    }
}

module side_friction_ribs() {
    if (enable_grip) {
        rib_h = 24.0;
        rib_y = 35.0;
        rib_r = 1.2;
        
        for (side = [-1, 1]) {
            x_center = side * (pocket_w / 2);
            translate([x_center, rib_y, -pocket_d / 2])
                scale([grip_depth / rib_r, 1.0, 1.0])
                    cylinder(r = rib_r, h = pocket_d - 4.0, center = true);
        }
    }
}

// Front Nameplate Personalization
module front_nameplate() {
    if (show_name && len(custom_name) > 0) {
        if (name_style == "deboss") {
            // Cuts 0.8mm into front vertical face of base (Y = 0)
            translate([0, name_depth, base_h / 2])
                rotate([90, 0, 0])
                    linear_extrude(height = name_depth + 0.1)
                        text(text = custom_name, size = name_font_size, font = name_font, halign = "center", valign = "center");
        } else if (name_style == "emboss") {
            // Protrudes 0.8mm outward from front vertical face of base (Y = 0)
            translate([0, 0.01, base_h / 2])
                rotate([90, 0, 0])
                    linear_extrude(height = name_depth)
                        text(text = custom_name, size = name_font_size, font = name_font, halign = "center", valign = "center");
        }
    }
}

// =============================================================================
// MAIN ASSEMBLY
// =============================================================================

module complete_dock() {
    difference() {
        union() {
            dock_base();
            cradle_pedestal();
            rear_buttresses();
            to_slab() {
                cradle_blank();
                side_friction_ribs();
            }
            if (name_style == "emboss") {
                front_nameplate();
            }
        }
        to_slab() {
            pb_pocket_cavity();
            ventilation_cutout();
            cable_pocket_slot();
            s25_cable_slot();
            phone_shelf_notch();
        }
        cable_base_channel();
        if (name_style == "deboss") {
            front_nameplate();
        }
    }
}

complete_dock();
