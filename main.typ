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

= Support Lecture

== Images
=== 2D Weighted Bilineaer Interpolation
Know the formula
#let int(x) = $floor.l #x floor.r$

$ x_0 = int(x) = 3, x_1 = 1 + x_0 = 4, y_0 = int(y) = 4\
  alpha = x - int(x) = 3.4 - 3 = 0.4\ 
beta = y - int(y) = 4.6 - 4 = 0.4\
w_11 = (1-alpha)(1-beta) = 0.6 times 0.4 = 0.24\
w_12 = (1-alpha)beta = 0.6 times 0.6 = 0.36\
w_21 = alpha (1-beta) = 0.4 times 0.4 = 0.16\
w_22 = alpha beta = 0.24\
i(x_0,y_0) = i(3,4)= 2\
i(x_0, y_1) = i(3,5) = 4\
i(x_1, y_0) = i(4,4) = 7\
i(x_1, y_1) = i(4,5) = 6\
i(3.4,4.6) = i(x_0, y_0)w_11 + i(x_0,y_1)w_12 + i(x_1, y_0)w_21 + i(x_1,y_1)w_22 = 4.48 $

=== 2D multichromatic indices

+ Calculate the memory address in bytes of pixel $P_(x y)=(10,12)$ (row-major, zero-based).\
  $ "Index" = (y times w_(max) + x) times n_"channels" = (12 times 64 + 10) times 3 = 2334 "bytes" $
+ How large is the full image
  $ 64 times 40 times 3 = 7680 "bytes" $
+ Assume the same image is stored in bit-plane layout. Since each RGB channel has 8 bits, we will have 8 planes per channel. In which plane is the most significant bit of the red channel located?
  $ 2^7 - "Idk he just said the answer" $
  #figure(
    image("images/bitplanes.png"),
    caption: "Further reading about bit-planes"
  )
+ What is the bit offset for the pixel $P_(x y) = (10,12)$ inside the plane found in the previous exercise?
  $ 12 times 64 + 10 = 778 $
== Operations on triangle (A,B,C)
- Computing Surface normal of the triangle(A,B,C)\
  Cross product of AB AC\
$ A = (0,0,0), B = (0,0,9), C = (3,0,3)\
V_1 = B - A = (0,0,9)\
V_2 = C - A = (3,0,3)\
V_1 times V_2 = (0,27,0) $
- Computing the point-normal plane equation for the triangle (A,B,C)
$ n times ( accent(P, ->) - accent(P_0, ->) ) = 0 $
$ accent(P, ->) - accent(P_0, ->) = mat(x;y;z) $

- Compute the area 
$ S = frac(1,2) ||V_1 times V_2|| = frac(1,2) ||n|| = frac(1,2) sqrt(27^2) = 13.5 $

- Compute the areas of the triangles constructed by $T_a = (A, P_1, B), T_b = (B,P_1,C), T_c = (C, P_1, A)$

Use the idea above

== Illumination calculations - Lambertian reflection model

+ Evaluate the Lambertian diffuse lighting for a vertex with the following information:
  - *P* $= (2,0,-2)$
  - *$L_("pos")$* $= (-7,10,8)$
  - *$N$* $= (0,1,0)$
  - up-axis $= (0,1,0)$
  $ l = l_A + l_D\
    l_D = max(0, accent(N, "^") accent(L, "^"))\
    accent(L, ->) = L_"pos" - P = (-9, 10, 10)\
    accent(x, "^") = frac((a,b), sqrt(a^2 + b^2)) => accent(L, "^") = frac((-9,10,10), sqrt(281))\
    N = (0,1,0) => accent(N, "^") = frac((0,1,0), sqrt(1)) = (0,1,0)\
    accent(N, "^") dot accent(L, "^") = mat(0;1;0) mat(frac(-9, sqrt(281)); frac(10, sqrt(281)); frac(10, sqrt(281))) = frac(10, sqrt(281))
   $
+ TODO EX 2

== Vertex Transformation - Compound Transformations - 2D

This is too cooked

To shift something towards / from the origin (x,y) use Translation matrix
$ mat(1, 0, -x; 0,1,-y;0,0,1) $
Rotation matrix
$ mat(cos(theta), -sin(theta), 0; sin(theta), cos(theta), 0; 0,0,1) $

