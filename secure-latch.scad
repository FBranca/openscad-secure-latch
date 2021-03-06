/**
 * Parametric Secure Latch
 *
 * The latch is made of 3 movings parts :
 * - The wall mount, with 2 holes for screws
 * - The grip
 * - The lever
*/
use <MCAD/2Dshapes.scad>;

$fs=0.05;
hole_axis_sep = 1;
parts_sep = 0.5;

// Grip
gp_thk = 3; // Grip thickness
gp_width = 17;
gp_length = 40;
gp_side_thk = 3; // Grip sides thickness

gp_plate_len = 30;
gp_round = gp_width/10;

gp_side_height = 12;
gp_side_upper_len = 30;
gp_side_lower_len = 21;


// Wall mount parameters
wm_thk = 5; // Thickness
wm_axis_diam = 3;
wm_axis_thk = 2.5; // Thickness of the part around the wall mount axis
wm_axis_z = 4.5;
wm_width = gp_width - 2*gp_side_thk - 2*parts_sep;
wm_len = 36;

screw_hole_d = 3; // Screw hole diameter
screw_head_d = 8; // Screw head diameter
screw_head_h = 2; // Screw head height (must be lower than wm_thk)
screw_offset = 10;


// Lever parameters
lv_thk = 3;
lv_axis_diam = 3;
lv_axis_z = 7;
lv_axis_x = 16;

lv_len = 50;


module 2d_side_plate (lb, lt, h, bp_thickness, r=4) {
    difference() {
        hull() {
            translate ([r,   r])    circle (r);
            translate ([h-r, r])    circle (r);
            translate ([h-r, lt-r]) circle (r);
            translate ([bp_thickness/2,   lb-bp_thickness]) circle (d=bp_thickness);
        }

        // Hole for the lever axis
        translate([lv_axis_z, lv_axis_x]) circle (d=lv_axis_diam+hole_axis_sep);
    }
}

module grip () {
    // First side plate
    rotate([0,-90,0])
    linear_extrude(gp_side_thk)
    2d_side_plate (gp_side_upper_len, gp_side_lower_len, gp_side_height, gp_thk, 4);

    // Second side plate
    translate([gp_width-gp_side_thk, 0, 0])
    rotate([0,-90,0])
    linear_extrude(gp_side_thk)
    2d_side_plate (gp_side_upper_len, gp_side_lower_len, gp_side_height, gp_thk, 4);

    // bottom plate
    linear_extrude (gp_thk)
    translate([gp_width/2-gp_side_thk, gp_plate_len])
    roundedSquare([gp_width, gp_plate_len], r=gp_round);

    // Axis for the wall mount
    translate([gp_width-gp_side_thk, wm_axis_z, wm_axis_z])
    rotate([0,-90,0])
    linear_extrude(gp_width)
    circle (d=wm_axis_diam);
}

// Wall mount
module wall_mount () {
    wm_hole_size = wm_axis_diam + hole_axis_sep;
    echo ("wall mount", wm_hole_size=wm_hole_size);

    wm_axis_holder_size = wm_axis_thk * 2 + wm_hole_size;
    echo ("wall mount", wm_axis_holder_size=wm_axis_holder_size);
    
    spacebtw_wm_gp = (gp_width - (gp_side_thk * 2) - wm_width) / 2;
    echo ("wall mount", spacebtw_wm_gp=spacebtw_wm_gp);
    
    translate([wm_width+spacebtw_wm_gp, 0])
    rotate([90,0,-90])
    linear_extrude(wm_width)
    union() {
        translate([-wm_axis_holder_size/2, wm_axis_holder_size/2])
        difference() {
            union() {
                // wall mount
                translate([wm_axis_holder_size/2, 0])
                square([wm_axis_holder_size/2 + wm_thk, wm_axis_holder_size], center=true);
                
                // Part around the wall mount axis
                circle(d=wm_axis_holder_size);
            }
            
            // Hole for the grip axis
            circle(d=wm_hole_size);
        }

        square([wm_thk, wm_len]);
    }
}

module wall_mount_with_screw_holes() {
    difference() {
        wall_mount();
        spacebtw_wm_gp = (gp_width - (gp_side_thk * 2) - wm_width) / 2;
        screw_x  = wm_width/2 + spacebtw_wm_gp;
        screw1_z = wm_len - screw_offset;
        screw2_z = wm_axis_holder_size + screw_offset;

        // Screw holes
        translate([screw_x, 0, 15]) rotate([90,0,0]) linear_extrude(wm_thk) circle (d=screw_hole_d);
        translate([screw_x, 0, 15]) rotate([90,0,0]) linear_extrude(screw_head_h) circle (d=screw_head_d);
        translate([screw_x, 0, 30]) rotate([90,0,0]) linear_extrude(wm_thk) circle (d=screw_hole_d);
        translate([screw_x, 0, 30]) rotate([90,0,0]) linear_extrude(screw_head_h) circle (d=screw_head_d);
    }
}


module 2d_lever() {
  polygon([
    [0, 0],
    [0, lv_len],
    [-30, lv_len],
    [-30, lv_len-0.5],
    [-30-lv_thk, lv_len-0.5],
    [-30-lv_thk, lv_len+lv_thk],
    [lv_thk, lv_len+lv_thk],
    [lv_thk, 0]
  ]); 
}

// Lever
module lever () {
    lv_axis_len = gp_width + 2*parts_sep + 2*lv_thk;
  
    // Lever axis
    translate([gp_width + parts_sep, 0, 0])
    rotate([0, -90, 0])
    linear_extrude(lv_axis_len)
    translate([lv_axis_z, lv_axis_x])
    circle (d=lv_axis_diam);
/*
    translate([gp_width + parts_sep - gp_side_thk, lv_axis_x, lv_axis_z - (lv_axis_diam/2)])
    rotate([0, -90, 180])
    linear_extrude(lv_thk)
    square ([lv_axis_diam, lv_len]);
  
    translate([-(parts_sep + lv_thk + gp_side_thk), lv_axis_x, lv_axis_z - (lv_axis_diam/2)])
    rotate([0, -90, 180])
    linear_extrude(lv_thk)
    square ([lv_axis_diam, lv_len]);
  */
  
  translate([0, 0, lv_thk])
  translate([gp_width + parts_sep, lv_axis_x, lv_axis_z - (lv_axis_diam/2)])
  rotate([0, 90, 180])
  linear_extrude(lv_thk)
  2d_lever();
}

union () {
    wall_mount_with_screw_holes();
    grip();
    lever ();
}
