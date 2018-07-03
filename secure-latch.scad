/**
 * Parametric Secure Latch
 *
 * The latch is made of 3 movings parts :
 * - The wall mount, with 2 holes for screws
 * - The grip
 * - The lever
*/
use <MCAD/2Dshapes.scad>;


screw_hole_d = 3; // Screw hole diameter
screw_head_d = 8; // Screw head diameter
screw_head_h = 2; // Screw head height


module 2d_side_plate (lb, lt, h, bp_thickness, r=4) {
    difference() {
        hull() {
            translate ([r,   r])    circle (r, $fs=0.1);
            translate ([h-r, r])    circle (r, $fs=0.1);
            translate ([h-r, lt-r]) circle (r, $fs=0.1);
            translate ([bp_thickness/2,   lb-bp_thickness]) circle (d=bp_thickness);
        }
        translate([7,16]) circle (d=4, $fs=0.1);
    }
}

module grip () {
    // First side plate
    rotate([0,-90,0]) linear_extrude(3) 2d_side_plate (30, 21, 12, 2, 4);

    // Second side plate
    translate([-14,0,0])
    rotate([0,-90,0]) linear_extrude(3) 2d_side_plate (30, 21, 12, 2, 4);

    // bottom plate
    linear_extrude (2)
    translate([-8.5,30]) roundedSquare([17,30], r=2, $fs=0.1);

    // Axis for the wall mount
    rotate([0,-90,0]) linear_extrude(17) translate([4.5,4.5]) circle (d=3, $fs=0.05);
}

// Wall mount
module wall_mount () {
    translate([-3.5,0])
    rotate([90,0,-90])
    linear_extrude(10)
    union() {
        translate([-4.5,4.5])
        difference() {
            union() {
                translate([4.5,0]) square([4.5+5,9], center=true);
                circle(d=9, $fs=0.05);
            }
            circle(d=4, $fs=0.05);
        }

        square([5,36]);
    }
}

module wall_mount_with_screw_holes() {
    difference() {
        wall_mount();
        
        // Screw holes
        translate([-8.5,0,15]) rotate([90,0,0]) linear_extrude(10) circle (d=screw_hole_d, $fs=0.05);
        translate([-8.5,0,15]) rotate([90,0,0]) linear_extrude(screw_head_h) circle (d=screw_head_d, $fs=0.05);
        translate([-8.5,0,30]) rotate([90,0,0]) linear_extrude(10) circle (d=screw_hole_d, $fs=0.05);
        translate([-8.5,0,30]) rotate([90,0,0]) linear_extrude(screw_head_h) circle (d=screw_head_d, $fs=0.05);
    }
}

// Lever
module lever () {
    translate([3.5,0,0])
    rotate([0,-90,0]) linear_extrude(24) translate([7,16]) circle (d=3, $fs=0.05);

    translate([0.5,16,5.5]) rotate([0,-90,180]) linear_extrude(3) square ([3,50]);
    translate([-20.5,16,5.5]) rotate([0,-90,180]) linear_extrude(3) square ([3,50]);
}

union () {
    wall_mount_with_screw_holes();
    grip();
    lever ();
}
    
    