// =============================================================================
// Premium 3D-Printable Desktop Wireless Charging Stand & Dock
// Hardware: boAt EnergyShroom PB331 Magnetic Power Bank (108 x 70 x 19 mm)
//           Samsung Galaxy S25 in Silicone MagSafe Case (150.5 x 74.5 x 10.5 mm)
// Manufacturing: Single-piece FDM/SLA, 100% support-free, fully manifold (Volumes: 2)
// =============================================================================

/* [Devices & Clearances] */
pb_h        = 108.0;   // boAt PB331 height (mm)
pb_w        = 70.0;    // boAt PB331 width (mm)
pb_d        = 19.0;    // boAt PB331 depth/thickness (mm)
phone_h     = 150.5;   // Cased Galaxy S25 height (mm)
phone_w     = 74.5;    // Cased Galaxy S25 width (mm)
phone_t     = 10.5;    // Cased Galaxy S25 thickness (mm)

tol_w       = 0.6;     // Width print tolerance (+0.6mm total -> 70.6mm pocket)
tol_d       = 0.5;     // Depth clearance (+0.5mm -> 19.5mm pocket)
tol_h       = 0.6;     // Height clearance (+0.6mm -> 108.6mm pocket)

pocket_w    = pb_w + tol_w;  // 70.6 mm
pocket_d    = pb_d + tol_d;  // 19.5 mm
pocket_h    = pb_h + tol_h;  // 108.6 mm

/* [Ergonomics & Camera Clearance] */
tilt        = 65.0;    // Viewing angle (65 deg backward from desk)
// Distance from top rim of PB331 pocket to top of cased phone.
// 48.0 mm guarantees the Galaxy S25 triple camera module sits completely
// above the 19mm-thick power bank with zero interference.
rim_below_phone_top = 48.0; 

/* [Phone Resting Ledge] */
ledge_len   = 12.0;    // Forward shelf depth (supports 10.5mm cased phone)
lip_h       = 3.0;     // Front retaining lip height (holds case, frees gestures)
lip_t       = 2.6;     // Lip wall thickness
notch_w     = 38.0;    // Center finger swipe gesture & speaker/port notch width

/* [Walls & Structure] */
wall_rear   = 3.5;     // Backrest wall thickness behind PB331 pocket
rail_w      = 4.0;     // Side rail width (4mm per side)
shelf_floor = 3.5;     // Floor thickness at base of pocket
fillet_r    = 2.0;     // Exterior edge radius
lead_in     = 1.5;     // 45-degree top entry chamfer for smooth PB insertion

/* [Ventilation Cutouts - Support Free Gothic Vents] */
vent_w      = 55.0;    // Total width of ventilation zone
vent_h      = 82.0;    // Total height of ventilation zone
vent_slots  = 7;       // Number of vertical slots
rib_t       = 2.8;     // Width of structural ribs between slots

/* [USB-C Cable Management] */
cable_slot_w = 16.0;   // USB-C pass-through slot width
cable_slot_t = 10.5;   // USB-C pass-through thickness
cable_exit_w = 14.0;   // Under-base exit groove width
cable_exit_h = 8.0;    // Under-base exit groove height

/* [Base & Anti-Tip Footprint] */
base_w      = 110.0;   // Wide stance anti-tip base width
base_h      = 12.0;    // Base ballast thickness
base_extra_f = 12.0;   // Front extension beyond dock toe
base_extra_r = 14.0;   // Rear extension beyond dock heel

/* [Friction Grip Retention] */
enable_grip = true;    // Side retention ribs
grip_depth  = 0.25;    // Protrusion into pocket (mm per side)

/* [Quality / Rendering] */
$fn = 36;

// =============================================================================
// DERIVED MATH & COORDINATE CALCULATIONS
// =============================================================================

rad = tilt * PI / 180;
c = cos(tilt);
s = sin(tilt);

dock_w = pocket_w + 2 * rail_w; // 78.6 mm
ledge_y = pocket_h + rim_below_phone_top - phone_h; // 6.1 mm

z_dock_rear = -(pocket_d + wall_rear); // -23.0 mm
z_lip_front = ledge_len + lip_t;        // 14.6 mm

function slab_gy(v, z) = v * c - z * s;
function slab_gz(v, z) = v * s + z * c;

p0_y_offset = base_extra_f - slab_gy(-shelf_floor, z_lip_front);
p0_z_offset = base_h - slab_gz(-shelf_floor, z_dock_rear);

top_rear_y = p0_y_offset + slab_gy(pocket_h, z_dock_rear);
base_d = top_rear_y + base_extra_r;

// =============================================================================
// MODULE DEFINITIONS
// =============================================================================

// Helper: 3D rounded box with filleted vertical edges and flat bottom
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

// Transform children from local slab frame to global tilted world frame
module to_slab() {
    translate([0, p0_y_offset, p0_z_offset])
        rotate([tilt, 0, 0])
            children();
}

// 1. Solid Anti-Tip Base Plate
module dock_base() {
    translate([-base_w / 2, 0, 0])
        filleted_box([base_w, base_d, base_h], r_fillet = fillet_r, flat_bottom = true);
}

// 2. The Main Cradle Slab Blank
module cradle_blank() {
    slab_len = pocket_h + shelf_floor;
    slab_thk = -z_dock_rear; // 23.0 mm
    
    // Smooth backrest envelope extruded with filleted X corners
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
    
    // Lower shelf block with flat phone resting plane at Y = ledge_y
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
        
    // Front lip structure with rounded top edge
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

// 3. Sturdy Pedestal & Buttress Structure bridging Cradle to Base
module cradle_pedestal() {
    hull() {
        // Tie into lower cradle in slab coordinates
        to_slab() {
            translate([-dock_w / 2, -shelf_floor, z_dock_rear])
                cube([dock_w, ledge_y + shelf_floor, z_lip_front - z_dock_rear]);
        }
        // Tie deeply into base plate
        y_front = p0_y_offset + slab_gy(-shelf_floor, z_lip_front);
        y_rear  = p0_y_offset + slab_gy(pocket_h * 0.40, z_dock_rear);
        translate([-dock_w / 2, y_front, 0])
            cube([dock_w, y_rear - y_front, base_h]);
    }
}

// 4. Rear Gussets supporting the upper tilted backrest
module rear_buttresses() {
    for (side = [-1, 1]) {
        x_pos = side * (dock_w / 2 - 3.5);
        hull() {
            // Anchor to upper rear backrest
            to_slab() {
                translate([x_pos - side * 1.5, pocket_h * 0.75, z_dock_rear])
                    sphere(r = 2.0);
                translate([x_pos - side * 1.5, pocket_h * 0.35, z_dock_rear])
                    sphere(r = 2.0);
            }
            // Anchor deeply into base plate
            anchor_y = p0_y_offset + slab_gy(pocket_h * 0.50, z_dock_rear);
            translate([x_pos - side * 1.5, anchor_y, 0])
                cylinder(r = 2.5, h = base_h + 1.0);
            translate([x_pos - side * 1.5, anchor_y - 20, 0])
                cylinder(r = 2.5, h = base_h + 1.0);
        }
    }
}

// 5. Internal PB331 Pocket Cavity & Entry Lead-in
module pb_pocket_cavity() {
    // Main pocket cavity
    translate([-pocket_w / 2, 0, -pocket_d])
        cube([pocket_w, pocket_h - lead_in, pocket_d + 1.0]);
        
    // 45-degree chamfered lead-in at top rim for scratch-free insertion
    hull() {
        translate([-pocket_w / 2, pocket_h - lead_in, -pocket_d])
            cube([pocket_w, 0.01, pocket_d + 1.0]);
        translate([-pocket_w / 2 - lead_in, pocket_h + 0.1, -pocket_d - lead_in])
            cube([pocket_w + 2 * lead_in, 0.01, pocket_d + lead_in + 1.1]);
    }
    
    // Top exit clearance above pocket
    translate([-pocket_w / 2 - lead_in, pocket_h, -pocket_d - lead_in])
        cube([pocket_w + 2 * lead_in, 20.0, pocket_d + lead_in + 1.5]);
}

// 6. 100% Support-Free Slotted Ventilation Cutouts (Gothic Pointed Chevrons)
module ventilation_cutout() {
    slot_w = (vent_w - (vent_slots - 1) * rib_t) / vent_slots; // ~5.4mm
    y_start = (pocket_h - vent_h) / 2;
    cut_depth = wall_rear + 4.0;
    cap_h = slot_w * 1.35; // Steep arch roof (>58 deg in world, support-free)
    
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

// 7. USB-C Cable Pass-Through at Pocket Floor
module cable_pocket_slot() {
    // Clean slot cut straight down through pocket floor
    translate([-cable_slot_w / 2, -shelf_floor - 2.0, -pocket_d + (pocket_d - cable_slot_t) / 2])
        cube([cable_slot_w, shelf_floor + 2.01, cable_slot_t]);
        
    // Angled channel running through pedestal into the base
    hull() {
        translate([-cable_slot_w / 2, -shelf_floor - 1.0, -pocket_d + (pocket_d - cable_slot_t) / 2])
            cube([cable_slot_w, 1.0, cable_slot_t]);
        translate([-cable_slot_w / 2, -35.0, -pocket_d])
            cube([cable_slot_w, 1.0, cable_slot_t + 4.0]);
    }
}

// 8. Under-Base Cable Exit Channel & Rear Egress
module cable_base_channel() {
    sy = p0_y_offset + slab_gy(-shelf_floor, -pocket_d / 2);
    
    // Open recessed groove under base to route cable neatly out the rear
    translate([-cable_exit_w / 2, sy - 8.0, -0.1])
        cube([cable_exit_w, base_d - sy + 15.0, cable_exit_h]);
        
    // Smooth transition between angled pedestal slot and base groove
    hull() {
        translate([-cable_exit_w / 2, sy - 8.0, -0.1])
            cube([cable_exit_w, 12.0, cable_exit_h]);
        translate([-cable_slot_w / 2, sy - 2.0, base_h - 1.0])
            cube([cable_slot_w, 12.0, 2.0]);
    }
}

// 9. Phone Screen Gesture & Speaker/Port Center Cutout
module phone_shelf_notch() {
    notch_y_start = ledge_y - 2.0;
    notch_y_len   = lip_h + 8.0;
    notch_z_len   = ledge_len + lip_t + 2.0;
    
    translate([-notch_w / 2, notch_y_start, -0.1])
        cube([notch_w, notch_y_len, notch_z_len]);
        
    // Smooth 45-degree chamfers on the inner notch edges
    for (s = [-1, 1]) {
        translate([s * notch_w / 2, notch_y_start, ledge_len / 2])
            rotate([0, 45, 0])
                cube([2.0, notch_y_len + 1.0, 2.0], center = true);
    }
}

// 10. Subtle Side Retention Friction Ribs
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

// =============================================================================
// MAIN ASSEMBLY
// =============================================================================

module complete_dock() {
    difference() {
        // Solid positive body
        union() {
            dock_base();
            cradle_pedestal();
            rear_buttresses();
            to_slab() {
                cradle_blank();
                side_friction_ribs();
            }
        }
        
        // Negative subtractions
        to_slab() {
            pb_pocket_cavity();
            ventilation_cutout();
            cable_pocket_slot();
            phone_shelf_notch();
        }
        cable_base_channel();
    }
}

// Render the unified, watertight, single-piece dock
complete_dock();
