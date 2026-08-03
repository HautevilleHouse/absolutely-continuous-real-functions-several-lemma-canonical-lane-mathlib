import canonicalLaneMathlib.AdmissibleClass

namespace HautevilleHouse
namespace AbsolutelyContinuousRealFunctionsSeveralLemmaCanonicalLaneLean

def ConstrainedAbsolutelyContinuousRealFunctionsSeveralLemmaClosure (A : AdmissibleClass) : Prop :=
  bridgeClosed A ∧ gateClosed A

theorem absolutely_continuous_real_functions_several_lemma_endgame (A : AdmissibleClass) :
    ConstrainedAbsolutelyContinuousRealFunctionsSeveralLemmaClosure A := by
  exact And.intro (bridge_from_admissible_class A) (gate_from_admissible_class A)

end AbsolutelyContinuousRealFunctionsSeveralLemmaCanonicalLaneLean
end HautevilleHouse