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
$
   "Image" I = I(V) \
   v in Z^N, n = 2, forall v in V \
   F( I(v = (x, y))) forall v in V \
   = I(x, y) ("attribute of the image") \
   f = mat(
      f(0, 0), f(0, 1), ..., f(0, N - 1);
      f(1, 0), f(1, 1), ..., f(1, N - 1);
      dots.v, dots.v, dots.v;
      f(M - 1, 0), f(M - 1, 1), ..., f(M - 1, N - 1);
   ) \
   I(x, y) in R^1 ("monochromatic") \
   I(x, y) in R^3 ("trichromatic") 
$

=== Interpolation

Images are only defined for discrete intervals. Interpolation is used for non-integer coordinates.

- Nearest Neighbour, choose the color of the closest discrete coordinates
- (weighted) Bilinear:
   take the four closest points, calculate a weighted average.
$
   "let" x &= 0.5, &&y = 1 \
   x_0 &= int(x), &&y_0 = int(y) \
   x_1 &= x_0 + 1, &&y_1 = y_0 + 1 \
   alpha &= x - x_0, &&beta = y - y_0 \
$
$
   w = mat(
      (1 - alpha)(1 - beta), (1 - alpha)beta;
      alpha(1-beta), alpha beta
   ) \
   I(x, y) = I(x_0, y_0) w_11 + I(x_0, y_1) w_12 + I(x_1, y_0) w_21 + I(x_1, y_1) w_22
$
- bicubic

== Grids

Images are a specialized form of grids

+ Regular: constant cell size
+ Rectilinear: variable vell size
+ curvilinear: non-orthogonal (you can make a circle into a grid)

structured grids:
- easy interpolation and containment checks
- often composed of trapezoidal base shapes (hexahedra in 3D)

Other grid-like structures: Cell elements
- Cell types - 0D: points
- Cell types - 1D: polylines #text(lime)[linear]
- Cell types - 2D:
   - triangle
   - quads
   - rectangle #text(green)[structured]
   - polygons
- Cell Types - 3D:
   - tetrahedra
   - cubes/ octahedra  #text(green)[structured]
   - prisms


== Properties of Grids and Meshes

Base primitives: polygons, polytopes (#text(red)[???]) and their extrusions (#text(red)[???])

Impacts complexity of:
- neighbourhood search
- interpolation
- point-in-primitive checks
- intersection tests
- mesh and grid element count

#block(breakable: false)[ #columns(2, [
   #pinkbox("Regularity", [
      For all cell primitives:
      - equiangilar: all (internal) angles are equal
      - equilateral: all bounding edges are of equal length
      - all cell primitives are of equal type
   ])

   #colbreak()

   #pinkbox("Linearity", [
      - the vertex sampling function of the grid or mesh is linear

      There is a linear relationship (sampling function) between the vertex
      coordinates and the shape function of the grid or mesh.
   ])

   #pinkbox("Isotropy", [
      For each cell primitive:
      - all its adjacent haave a uniform scaling to its own size and shape
      - shape preserving saling
   ])

])]

== Compound Objects

Combining _sets_ of homogeneous representation classes to represent
complex shapes beyond of what the base representation supports.

*Benefits*
- represent shapes of higher dimensions
- conforming to semantic boundaries
- manage memory footprints
- allow for simpler shape-to-shape morph

=== Mesh-based

*piecewise linear complexes*

*polygon soups*
- collection of polygons

#image("images/compound_meshbased.png")

=== Shape-based

Solid object defined by 3D base primitives.

== Algebraic geometry

Every linear, bound shape can be described by a linear function in its geometric space

*innside/outside*: instead of being either inside or outside, we can also compute the distance to 
the boundary, the whole geometry can be described be $f(x, z) = 0$


= Transformations

== Transformations in 2D

- Move
- deform
- switch between coordinate systems:
   - global
   - camera
   - image
   - light source

#columns(2, [
#purplebox("Scaling", [
   - scaling factors $s_x, s_y$
   - condition: $s_x != 0, s_y != 0$
   - $p' = (s_x p_x, s_y p_y)^T$
])

#purplebox("Mirror", [
   mirror on a Principal axis: negate scale _of the other axis_
])

#purplebox("Shearing", [
   $
      S h_"hor" = S H_x = mat(1, s h_x; 0, 1) \
      S h_"vert" = S H_y = mat(1, 0; s h_y, 1)
   $
])

#colbreak()

#purplebox("Counter-clockwaise Rotation", [
   $
      p &= vec(p_x, p_y) = vec(r cos alpha, r sin alpha)\
      bold(R) &= mat(cos theta, - sin theta; sin theta, cos theta) \
      p' = bold(R) p &= vec(r cos(alpha + theta), r sin(alpha + theta))
   $
])

#purplebox("Translation", [
   $
      p' = p + t
   $
])
])

== Transformations in 3D

*scaling, reflection, and Translation* still work the same.

#purplebox("Rotation", [
   $
      R_x (theta) = mat(1, 0, 1; 0, cos theta, -sin theta; 0, sin theta, cos theta) \ 
      R_y (theta) = mat(cos theta, 0, sin theta; 0, 1, 0; - sin theta, 0, cos theta) \ 
      R_z (theta) = mat(cos theta, - sin theta, 0; sin theta, cos theta, 0; 0, 0, 1) \ 
   $
])

#purplebox("Shearing", [
   $
      S h_x = mat(1, 0, 0; s h_y, 1, 0; s h_z, 0, 1) \ 
      S h_y = mat(1, s h_x, 0; 0, 1, 0; 0, s h_z, 1) \ 
      S h_z = mat(1, 0, s h_x; 0, 1, s h_y; 0, 0, 1) \ 
   $
])


#purplebox("Projection", [
   project a 3D scene onto a 2D screen

   - Orthographic projection: make $z = 0$ for everything in the scene
      
      A form of parallel projection where all projection lines 
      are orthogonal to the projection plane.

   - Perspective projection
      
])


= Color and Intensity representations

*Achromatic / Monochromatic and Trichromatic*

- RGB: additive
- CMYK: subtractive (print and paint)

*Quantization and Memory*

- $< 8 "bit", 8 "bit", 16 "bit", 32 "bit"$


= The virtual Camaera

conditions:
- centered view at $(x,y)_"proj" = (0,0)$
- fixed aspect ratio

Projection matrix is used to transform objects to the eye-view of the 
camera.

= transforming Scene Objects

move it to the $(0, 0)$, then do what you need, then move it back.

= Color from Illumination
#table(
   columns: (50%, 50%),
   table.header([*Light as a Particle*], [*Light as a Wave*]),
   [ *Emission* ], [ *Scattering* ],

   [ *Reflection*: objects reflect photons opposite to the angle, for a 
   certain spectra of the wavelength. ],
   [ *interference* ],

   [ *Refraction*: translucent objects reflect photons internally, bending
   them on an angle. ], 
   [ *Diffuse reflection* ],

   [ *Total internal reflection* ], [ *Absorption* ],

   [*Shadowing*], [ *Attenuation* ],
)



simplifications:
we only care about _local_ illumination, specifically diffuse reflection


*Lambertian (diffuse) surface reflection*:
- idealized matte surface
- independent of view direction

$
   I_D = cos theta = N L
$


Sometimes diffuse reflection is not enough, and we need _ambient reflection_

We can considure it as just a constant

$
   I = I_A + I_D
$

= Renduring Pipeline and Image Generation

#columns(4, [
#pinkbox("Application", [
   - Object definition / creation
   - world layout
   - AI & world logic (physics fluid + collisions)
   - user interaction
])

#colbreak()

#pinkbox("Geometry/Scene composition", [
   - object and camera transformation
   - vertex processing
   - projection
   - perspective division
   - clipping
   - window / viewport / screen mapping
])

(
Polygon tessellation, triangle tessellation,
geometry processing
)

#colbreak()

#pinkbox("Image Generation", [
   - rasterizer or raycaster
   
   #line()

   (volume) ray casting vs ray tracing:
   - ray casting doesn t reflect, it just checks which objects can
      be seen
])

#colbreak()

#pinkbox("Display", [
   - output to screen
])

])

= Visualization

"Computer-based visualization systems provide visual representations of
datasets intended to help people carry out tasks more effectively."

#block(breakable: false)[ #columns(2, [

#Definitionbox("Marks", [
   geometric elements used to identify items of a dataset.

   e.g. points, lines, areas, volumes
])

#Definitionbox("Mapping function", [
   transform data into marks and channels.
   - 2D: color maps
   - 3D: transfer functions
   map _attributes_ to a scale of the _channel_
])

#colbreak()

#Definitionbox("Channels", [
   encode values of the data associated with items in the dataset.

   e.g. position on an axis, length, width, angle, color, brightness,
   saturation

   not all methods are equally good in all contextes.

   e.g. numeric, ordinal, categorical.

   Also keep in mind perspective limitiations, like color blindness
])

]) ]

== The Visualization Pipeline

+ acquisition
   - obtain data from data source
   - highly domain specific
   - measurements: noisy, unstructured
   - simulation: data intense
+ Data $D$
+ Filtering
   - data transformation for mapping
   - pre-processing: cleaning
   - dynamic processing: organize, smoothing, interpolation
+ Transformed data $D'$
+ Mapping
   - set up coordinate system
   - layout
   - geometry transform
   - color and transparency mapping
   - borders
+ Representation $R$
+ Renduring
   - *computer graphics*
      - rasterization, ray tracing, scatterplots
   - address:
      - clipping and occlusion
      - illumination
+ Visual $V$

== Challenges and Best Practices

- clutter
- context: show focus while preserving context
- encoding adequacy
- design for cisual deficiencies
- qualifying evaluation

= OpenGL

- state machine
- cross platform
- rendering pipeline abstraction
- shader language and flexibility
- integration

== Setup

- needs a render target (screen, window, canvas, memory buffer)
- OpenGL draws a framebuffer, platforms implement transforming it
   to their render target

+ create OpenGL context with target (connect to GPU, set the bit depth, etc.)
+ call `init()`
   define background color, enable depth buffer, etc.
+ enter rendering loop

== State Machine

advantages:
- every state has a default, every behavior is defined
- only change the states you need to

disadvantages:
- lots of target switching
- easy to lost overview
- some simple functionalities require a lot of code
- a lot of similarly named functions

== Precessing Modes

#pinkbox("Immediate mode", [
   'novice mode', send data piece by piece.
   - `glBegin() ... glEnd()`
   - geometry is sent _immediately_ to the gpu
   - geometry is rendered _roughly_ in order sent

   advantage: you can _control_ the render order

   disadvantages:
   - forces GPU to tun _in sync_ with the host code (slow)
   - need to transmit entire geometry vie PCIe to GPU _every frame_ (very slow)
   - prevents efficient parallel scheduling of GPU (slow)

   *old mode, requires compatability mode to use*
])

=== OpenGL *$2.0^+$*

- Programmable pipeline, shaders & buffer objects.
- graphics controllder by the device
- send geometry once

== Defining simple verteces and attributes

#image("images/opengl.png")

== Transformations and targets

*Pipeline*

- you define transformation vectors and matricies directly
- transformations are done on GPU _in shaders_, _uniform variables_

*Fixed-Functionality*

- transformations are done on _host_, using OpenGL functions


== From Immediate-mode to shaders

#purplebox("Shaders", [
   - small c-like programs executed on the GPU for every _vertex_ or _pixel_
   - operate under a _shared memory principle_
   - processing of a single vertex/pixel is done _independently_

   *Types of shaders*:
   - *vertex shader*
   - tessellation shader
   - geometry shader
   - *fragment shader*
   - compute shader
])

= VTK

#image("images/visualization.png")


== Core Concepts

*pipeline*: Reader|Source → Filter(s) → Mapper → Actor (→ Interactor) → Renderer → RenderWindow

*Dataset*:
- point
- line/polyline
- polygon
- polytopes
- grids
- ImageData

*Filter*:
- sampling/glyphing
- geometric reconstruction
- attribute derivation
- spactial embedding

*Mapper*:
- performs _visual mapping_: colormaps, channel modulation, scaling, glyphs

*Actor*:
- visual representation in scene
- interactable item
- contains mappers, volumes, etc.

*Renderer*:
- contains viewport, camera, etc.
- executes the render pipeline

A Renderer can have many actors, a RenderWindow can have many Renderers




= Tutorials

== Tutorial 1

*Linear Algebra*

#pinkbox("vector negation and vector inversion", [
   - negating a vector is the same as flipping it the opposite direction
   - vector inversion is the negative of the transpose
])

#pinkbox("wedge product", [
   - in 2D, $u and u = u_1 v_2 - u_2 v_1$
])

#pinkbox("axis reflection", [
   #let v = $bold(v)$
   #let n = $bold(n)$
   #let r = $bold(r)$
   To reflect vector #v on the axis of the _normalized_ vector #n:
   $
   #r = #v - 2 (#v dot #n) #n
   $
])

#bluebox("Matrix", [
   $ 
      4 times 2 "matrix" \
      a = mat(
         a_11, a_12;
         a_21, a_22;
         a_31, a_32;
         a_41, a_32;
      )
   $
])

#pinkbox("vector matrix dot product", [
   *Row vector*

   $1 times n "vector", n times m "matrix" => 1 times m "vector"$

   $
      A = mat(1, 2; 3, 4), v = mat(5, 6) \
      v A = mat(5, 6) mat(1, 2; 3, 4) = mat(5 dot 1 + 6 dot 3, 5 dot 2 + 6 dot 4) = mat(23, 34)
   $
])

#pinkbox("matrix vector dot product", [
   *Column vector*
   
   $m times n "matrix", n times 1 "vector" => m times 1 "vector"$

   $
      A = mat(1, 2; 3, 4), v = vec(5, 6) \
      A v = vec(1 dot 5 + 2 dot 6, 3 dot 5 + 4 dot 6) = vec(17, 39)
   $
])

- matrix matrix dot product

#pinkbox("matrix inversion", [
   - square matrix
   - the vectors are linearly independent
   - nonzero determinant
])

#pinkbox("sampling lines in descrete space (bresenhams) + implicit line equations", [
   A line going through points $A "and" B$ in the form $A x + B y + C = 0$
   $
      "direction vector": u = B - A \
      "normal vector": n = (- u_y, u_x) \
      n dot u = 0 \
      n_x x + n_y y + C = 0 \
      "since we know" A "is on the line": \
      n_x A_x + b_y A_y + C = 0 \
      "solve for" C "then simplify"
   $

   *Brsenham's algorithm* pseudo code

   ```
   y = y0
   for x = x0 to x1 do:
      draw(x, y)
      if f(x + 1, y+ 0.5) < 0 then
         y = y + 1
   ```
   $y_0, x_0$ are the integer parts of $x, y$

   $f(x, y)$ is the implicit equation from above
])

#pinkbox("circles in descrete space", [
   the parametric equation for the circle in terms of angle:
   $
      C = R dot vec(cos theta, sin theta)
   $
   where $C$ is the center and $R$ is the radius


])

- If pixels in an image are accessed as (x, y) with x rightwards and y downwards. If the origin
   is at the top-left corner, is this coordinate system row-major or column-major?
   
   row, cause first we go right, then we go down


#pinkbox("indices", [
   - bit-plane?


])

- nearest neighbour

- weighted bilinear

== Tutorial 2

#pinkbox("Ear clipping", [
   
])

#pinkbox("containment test: circle", [
   must satisfy:
   $
      (x - C_x)^2 + (y - C_y)^2 <= R^2
   $
   where $C$ is the center of the disk, and $R$ is the radius
])

#pinkbox("containment test: sphere", [
   $
      | P - C | <= R
   $
   where $C$ is the center of the sphere, and $R$ is the radius
])

#pinkbox("line intersection test", [
   equate the two lines, solve
])

#pinkbox("ray-circle intersection", [
   use the parametric equation of the ray, and circle equate and solve
])

#pinkbox("ray triangle intersection", [
   write the parametric equation for the ray, and each side of the
   triangle, equate and solve

])

#pinkbox("ray sphere intersection", [
   move everything so that the sphere is at the origin, write down the implcite functions for
   the ray, and sphere.
   $
      P' = O - C \
      R = P' + t D \
      S = || R ||^2 = r^2
   $

   equate and solve
])

#pinkbox("lambertian reflection", [
   to compute the diffuse light intensity with lambert s law

   $
      P, L_"pos", N \

      I_D = max(0, N dot L_"dir") \

      L_"dir" = (L_"pos" - P) / (||L_"pos" - P||)
   $
])


== Tutorial 3



== Matrix multiplication

(column vectors also)

== rotations on a plane

== Rotation matrix

$
   R_x (theta) = mat(1, 0, 1; 0, cos theta, -sin theta; 0, sin theta, cos theta) \ 
   R_y (theta) = mat(cos theta, 0, sin theta; 0, 1, 0; - sin theta, 0, cos theta) \ 
   R_z (theta) = mat(cos theta, - sin theta, 0; sin theta, cos theta, 0; 0, 0, 1) \ 
$

https://en.wikipedia.org/wiki/Rotation_matrix?useskin=vector


== All types of color maps

wtf is colon major order? (the way to order matricies in 1D)

opengl compatability profile features on all platforms

VTK

rasterization

= Mock Exam

*Ray tracing impact:*
- Frame pixel resolution (i.e. width & height [px]): #text(red, [ Significant impact ])
- Recursion depth of secondary rays: #text(red, [ Significant impact ])
- Number of scene objects: #text(yellow, [Some impact])
- Size of scene objects: #text(green, [No impact])
- Content-to-pixel coverage: #text(yellow, [Some impact])
- Presence and number of textures per surface: #text(green, [No impact])
- Number of light sources: #text(yellow, [Some impact])
- The near-far ratio of the virtual camera: #text(green, [No impact])

basic operation of rasterization is the pixel-/point-in-triangle test

in OpenGL's compatability profile:
- zBuffer / Depth Buffer: #text(green, [supported])
- Order-Independent Alpha Blending: #text(red, [not supported])
- Immediate-Mode Rendering: #text(green, [supported])
- GPU-side Object Transformation, Clipping & Lighting: #text(green, [supported])
- Predefined shader variables & functions: #text(green, [supported])
- Programmable Compute Shader: #text(red, [not supported])
- Programmable Vertex Shader: #text(green, [supported])
- Buffer Object Rendering: #text(green, [supported])

*Channels ranked by effectiveness:*
+ lateral position on common scale
+ tilt / orientation / angle
+ 2D area
+ depth, i.e. 3D position
+ (colour) saturation
+ curvature

*VTK Mappers:*
- The mapper performs the visual mapping (i.e. the visual encoding) of data types and data attributes to marks and channels.
- The mapper functionalities depend on the data type that is to be mapped.
- The mapper modulates the scale- and colour of the marks based on the attributes of the data.
- A (VTK Volume) Raycaster is a type of mapper.
- Glyphs are a type of mapper.


= Support Lecture

== Images
=== 2D Weighted Bilineaer Interpolation
Know the formula

$ 
   x_0 = int(x) = 3, x_1 = 1 + x_0 = 4, y_0 = int(y) = 4\
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
   i(3.4,4.6) = i(x_0, y_0)w_11 + i(x_0,y_1)w_12 + i(x_1, y_0)w_21 + i(x_1,y_1)w_22 = 4.48 
$

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
$ 
   A = (0,0,0), B = (0,0,9), C = (3,0,3)\
   V_1 = B - A = (0,0,9)\
   V_2 = C - A = (3,0,3)\
   V_1 times V_2 = (0,27,0) 
$
- Computing the point-normal plane equation for the triangle (A,B,C)
$
   n times ( accent(P, ->) - accent(P_0, ->) ) = 0 
   accent(P, ->) - accent(P_0, ->) = mat(x;y;z) 
$

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
   $
      l = l_A + l_D\
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

