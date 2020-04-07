ReadPackage( "DerivedCategories", "examples/pre_settings.g" );
######################### start example #################################

# create graded polynomial ring
S := GradedRing( HomalgFieldOfRationalsInSingular( ) * "x0,x1" );

# create subcategory of free graded modules of rank 1
free_of_rank_one := FullSubcategoryGeneratedByGradedFreeModulesOfRankOne( S );

# create the subcategory generated by {𝓞 (i)|i=-2,-1}
o := SetOfKnownObjects( free_of_rank_one );
full := FullSubcategoryGeneratedByListOfObjects( [ o[-2], o[-1] ] );

# create a Beilinson functor
B := BeilinsonFunctorIntoHomotopyCategoryOfAdditiveClosureOfAlgebroid( S );

# restrict it to {𝓞 (i)|i=-2,-1}
B := RestrictFunctorToFullSubcategoryOfSource( B, full );

# compute the image of B as full subcategory generated by list of objects
image_B := ImageOfFullyFaithfullFunctor( B );

# connect the two category full & image_B with functors
U := IsomorphismOntoImageOfFullyFaithfulFunctor( B );
U := ExtendFunctorToAdditiveClosureOfSource( U );
U := ExtendFunctorToHomotopyCategories( U );

V := IsomorphismFromImageOfFullyFaithfulFunctor( B );
V := ExtendFunctorToAdditiveClosureOfSource( V );
V := ExtendFunctorToHomotopyCategories( V );

# use the image to define a strong full exceptional collection
vertices_labels := [ "𝓞 (-2)", "𝓞 (-1)" ];
collection := CreateExceptionalCollection( image_B : vertices_labels := vertices_labels );

# embedd the ambient in some derived category where homology can be computed
I := EmbeddingFunctorFromAmbientCategoryIntoDerivedCategory( collection );

F := ConvolutionFunctorFromHomotopyCategoryOfAdditiveClosureOfAlgebroid( collection );
G := ReplacementFunctorIntoHomotopyCategoryOfAdditiveClosureOfAlgebroid( collection );

C := AmbientCategory( collection );
D := AsCapCategory( Source( F ) );

FF := ExtendFunctorToCategoryOfTriangles( F );
GG := ExtendFunctorToCategoryOfTriangles( G );

quit;

# create object in the ambient category
a := RandomObject( C, [ -3, 3, 3 ] );

# take it by G and bring it back by F
FG_a := F(G(a));

# Embedding both of them in some derived category to compare homologies
I_a := I( a );
I_FG_a := I( FG_a );

# compute homologies
List( [ -3 .. 3 ], j -> [ HomologyAt( I_a, j ), HomologyAt( I_FG_a, j ) ] );

# create an exact triangle in C
alpha := RandomMorphism( C, [ [-2,2,2], [-2,2,2], [2] ] );
st_alpha := StandardExactTriangle( alpha );
GG_st_alpha := GG( st_alpha );
IsWellDefined( GG_st_alpha );
w := WitnessIsomorphismOntoStandardExactTriangle( GG_st_alpha );
List( [ 0, 1, 2, 3 ], i -> IsIsomorphism( w[ i ] ) );

# create an exact triangle in D
alpha := RandomMorphism( D, [ [-2,2,2], [-2,2,2], [2] ] );
st_alpha := StandardExactTriangle( alpha );
FF_st_alpha := FF( st_alpha );
IsWellDefined( FF_st_alpha );
w := WitnessIsomorphismOntoStandardExactTriangle( FF_st_alpha );
List( [ 0, 1, 2, 3 ], i -> IsIsomorphism( w[ i ] ) );
List( [ 0, 1, 2, 3 ], i -> IsIsomorphism( I( w[ i ] ) ) );
