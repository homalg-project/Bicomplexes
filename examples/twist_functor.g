ReadPackage( "DerivedCategories", "examples/pre_settings.g" );
######################### start example #################################

# create graded polynomial ring
S := GradedRing( HomalgFieldOfRationalsInSingular( ) * "x0..2" );

# create subcategory of free graded modules of rank 1
free_of_ranke_one := FullSubcategoryGeneratedByGradedFreeModulesOfRankeOne( S );

# create the subcategory generated by {𝓞 (i)|i=-2,-1,0}
o := SetOfKnownObjects( free_of_ranke_one );

full_1 := FullSubcategoryGeneratedByListOfObjects( [ o[-2], o[-1], o[0] ] );
full_2 := FullSubcategoryGeneratedByListOfObjects( [ o[-1], o[0], o[1] ] );

T_1 := CapFunctor( " _ ⊗ S( 1 ) functor", full_1, full_2 );
AddObjectFunction( T_1,   o -> UnderlyingCell( UnderlyingCell( o ) )[ 1 ] / free_of_ranke_one / full_2 );
AddMorphismFunction( T_1, { s, m, r } -> UnderlyingCell( UnderlyingCell( m ) )[ 1 ] / free_of_ranke_one / full_2 );

T_1 := ExtendFunctorToAdditiveClosureOfSource( T_1 );
T_1 := ExtendFunctorToHomotopyCategories( T_1 );

T_2 := CapFunctor( " _ ⊗ S( -1 ) functor", full_2, full_1 );
AddObjectFunction( T_2,   o -> UnderlyingCell( UnderlyingCell( o ) )[ -1 ] / free_of_ranke_one / full_1 );
AddMorphismFunction( T_2, { s, m, r } -> UnderlyingCell( UnderlyingCell( m ) )[ -1 ] / free_of_ranke_one / full_1 );

T_2 := ExtendFunctorToAdditiveClosureOfSource( T_2 );
T_2 := ExtendFunctorToHomotopyCategories( T_2 );

# create a Beilinson functor
B := BeilinsonFunctorIntoHomotopyCategoryOfQuiverRows( S );
#B := BeilinsonFunctorIntoHomotopyCategoryOfAdditiveClosureOfAlgebroid( S );
C := AsCapCategory( Range( B ) );

# embedd C in some derived category
I := EmbeddingFunctorIntoDerivedCategory( C );

# restrict B to {𝓞 (i)|i=-2,-1,0}
B_1 := RestrictFunctorIterativelyToFullSubcategoryOfSource( B, full_1 );

# restrict B to {𝓞 (i)|i=-1,0,1}
B_2 := RestrictFunctorIterativelyToFullSubcategoryOfSource( B, full_2 );

# compute the image of B_1 as full subcategory generated by list of objects
image_B_1 := ImageOfFullyFaithfullFunctor( B_1 );

# create strong full exceptional collection
name_for_quiver := "quiver{𝓞 (-2) -{3}-> 𝓞 (-1) -{3}-> 𝓞 (0)}";
name_for_algebra := "End( ⊕ {𝓞 (i)|i=-2,-1,0} )";
collection_1 := CreateExceptionalCollection( image_B_1 :
                      name_for_underlying_quiver := name_for_quiver,
                      name_for_endomorphism_algebra := name_for_algebra
                    );

# connect full_1 with image_B_1
U_1 := IsomorphismIntoImageOfFullyFaithfulFunctor( B_1 );
U_1 := ExtendFunctorToAdditiveClosureOfSource( U_1 );
U_1 := ExtendFunctorToHomotopyCategories( U_1 );

V_1 := IsomorphismFromImageOfFullyFaithfulFunctor( B_1 );
V_1 := ExtendFunctorToAdditiveClosureOfSource( V_1 );
V_1 := ExtendFunctorToHomotopyCategories( V_1 );

# compute the image of B_2 as full subcategory generated by list of objects
image_B_2 := ImageOfFullyFaithfullFunctor( B_2 );

# connect full_2 with image_B_2
U_2 := IsomorphismIntoImageOfFullyFaithfulFunctor( B_2 );
U_2 := ExtendFunctorToAdditiveClosureOfSource( U_2 );
U_2 := ExtendFunctorToHomotopyCategories( U_2 );

V_2 := IsomorphismFromImageOfFullyFaithfulFunctor( B_2 );
V_2 := ExtendFunctorToAdditiveClosureOfSource( V_2 );
V_2 := ExtendFunctorToHomotopyCategories( V_2 );

# create strong full exceptional collection
name_for_quiver := "quiver{𝓞 (-1) -{3}-> 𝓞 (0) -{3}-> 𝓞 (1)}";
name_for_algebra := "End( ⊕ {𝓞 (i)|i=-1,0,1} )";
collection_2 := CreateExceptionalCollection( image_B_2 :
                      name_for_underlying_quiver := name_for_quiver,
                      name_for_endomorphism_algebra := name_for_algebra
                    );

#
TT_1 := PreCompose(
        [
          ReplacementFunctor( collection_1 ),
          V_1,
          T_1,
          U_2,
          ConvolutionFunctor( collection_2 )
        ]
      );

TT_2 := PreCompose(
        [
          ReplacementFunctor( collection_2 ),
          V_2,
          T_2,
          U_1,
          ConvolutionFunctor( collection_1 )
        ]
      );

#####################
quit;
S_0 := TwistedGradedFreeModule( S, 0 );
B_S_0 := B( S_0 );
HomStructure( B_S_0, TT_1( B_S_0 ) );
HomStructure( B_S_0, TT_1( TT_1( B_S_0 ) ) );

HomStructure( TT_2( B_S_0 ), B_S_0 );
HomStructure( TT_2( TT_2( B_S_0 ) ), B_S_0 );

alpha := RandomMorphism( C, [[-2,2,2], [-2,2,2], [2]] );
IsZero( alpha );
beta := RandomMorphismWithFixedSource( Range( alpha ), [ [-2,2,2], [2] ] );
IsZero( beta );
CheckFunctoriality( TT_1, alpha, beta );
CheckFunctoriality( TT_2, alpha, beta );

