#import "lib.typ": *

#let title = [Introduction to Computer Graphics and Visualization]
#set page(
   paper: "a4",
   header: align(left, title),
   numbering: "1",
)

#align(center, text(17pt)[
   *#title*

   Matteo Bongiovanni\
   Roman Gazarek
])


- Brsenham line algorithm
- Brsenham circle algorithm


= Fundamentals: Object Representation and Modelling

== Points and Verticies

#Definitionbox("Objects", [
   All displayable _shapes_ in a scene

   They can be represented as:
   - Boundaries
   - algabraic shapes
   - sets of verticies and their connectivity
   - sets of points
   - values in an image
])

Every _bounded_ shape has:
- an interior
- a boundry
- an exterior

#pinkbox("Orientation and Winding",[
   Left hand: clockwise winding order

   Right hand: counter clockwise winding order
])

#Definitionbox("", [
   *Point*: a location in space

   *Vertex*: a point and _its associated attributes_

   Points have no dimension, for illustration purposes, theu have a _pointsize_ attribute

   *Neighbourhood*: How points relate to one another.

   Points are inherently unconnected, but relate to each other by _distance_. Neighbourhoods 
   require computing a distance matrix. They are _delimited_. e.g. by a radius, or the $k$ nearest
   points (kNN) (appropiate selection of $k$ is difficult)
])

== Verticies and Connectivity

Object shapes have some boundry, possible boundry descriptions include:
- Corner ponts
- Connector line between points
- actual structure definitions

A _boundry_ contains:
- corner points: object *geometry* (vertices)
- point links: corner *topology* (edges)

A geometry is a collection of vertices and edges

#pinkbox("How to establish connectivity between vertices", [
   - Explicitly given (Meshes)
   - implied by structure (grids and images)
   - interactively defined (user selection)
   - defining the neighbourhood of points
   - triangulating the vertices
])

== Principal Shapes

#Definitionbox("Circle", [
   $
      d &= 2 r \
      v_c &= v_0 ; (x, y) = (x_c, y_c) + (x_"circle", y_"circle") \
      A &= pi r^2 \ 
      C &= 2 pi r 
      (x - x_0)^2 + (y - y_0)^2 = r^2 "[circle]"
   $
])

#Definitionbox("Ellipse", [
   //TODO: is this even needed?
   $
      d &= 2 a
      (x - x_0)^2 + (y - y_0)^2 <= r^2 "[ellipse]" 
   $
])


== Polylines and Polygons

#Definitionbox("Polyline", [
   A continuous line made of connected straight line segments

   Open/closed: if the start and end points are the same.
])

#Definitionbox("Polygon", [
   A polygon has a coherent winding: internal boundaries have the opposite winding of
   external boundaries.
   - Area:
      Calculate polygon area seperately for each boundary

      (formula is BS)

   *Simple Polygon*: no self-intersections or holes.
      - Area: $A = 1/2 * (x_1 * y_2 - x_2 * y_1 + x_2 * y_3 - x_3 * y_2 + 
         ... + x_n * y_1 - x_1 * y_n)$

   closed polylines are simple polygons

   - convexity: there does not exist a line between the vertices that crosses or is outside
      the boundry of the polygon
   - Inside/outside test:
      + Ray-casting: quick, but numerically unstable, shot ray from left-frame, count the number
         of times it crosses the polygon before arrving at the point, if it s an odd number,
         it's inside.
      + Winding number: slow, but stable, draw some trianlges, do some math, if the winding sum
         $!= 0$, the point is inside the polygon.
])


== Surface Meshes

We need meshes for non-simple polygons. Holes and self-intersections are difficult, so
we use something simpler than polygons: triangles.

We define mesh geometry as geometry (vertices and edges) and the set of triangles they span.

All edges with 2 adjacent triangles: interior edges
All edges with 1 adjacent triangle: boundary edges

#pinkbox("How to obtain triangular meshes", [
   ear clipping
])

inside/outside test: use interpolation via barycentric coordinates

== Images

TODO

= Revision

== Matrix multiplication

(column vectora also)

== rotations on a plane

== All types of color maps

wtf is colom major order? (the way to order matricies in 1D)

opengl compatability profile features on all platforms

VTK

rasterization
