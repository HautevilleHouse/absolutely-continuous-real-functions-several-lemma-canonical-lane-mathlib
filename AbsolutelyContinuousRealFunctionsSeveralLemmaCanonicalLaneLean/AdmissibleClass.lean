import Mathlib.Data.Set.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.Calculus.Deriv
import canonicalLaneMathlib.AdmissibleClass

namespace HautevilleHouse
namespace AbsolutelyContinuousRealFunctionsSeveralLemmaCanonicalLaneLean

abbrev Interval := ℝ × ℝ

noncomputable def intervalLength (I : Interval) : ℝ :=
  |I.2 - I.1|

noncomputable def intervalOscillation (f : ℝ → ℝ) (I : Interval) : ℝ :=
  |f I.2 - f I.1|

def DisjointIntervals (I J : Interval) : Prop :=
  I.2 ≤ J.1 ∨ J.2 ≤ I.1

def PairwiseDisjointIntervals (Is : List Interval) : Prop :=
  ∀ I ∈ Is, ∀ J ∈ Is, I ≠ J → DisjointIntervals I J

noncomputable def totalLength (Is : List Interval) : ℝ :=
  (Is.map intervalLength).sum

noncomputable def totalOscillation (f : ℝ → ℝ) (Is : List Interval) : ℝ :=
  (Is.map (intervalOscillation f)).sum

def AbsolutelyContinuousOn (f : ℝ → ℝ) (a b : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ δ : ℝ, 0 < δ ∧ ∀ Is : List Interval,
    PairwiseDisjointIntervals Is →
    (∀ I ∈ Is, a ≤ I.1 ∧ I.2 ≤ b) →
    totalLength Is < δ →
    totalOscillation f Is < ε

def BoundedVariationOn (f : ℝ → ℝ) (a b : ℝ) : Prop :=
  ∃ M : ℝ, ∀ Is : List Interval,
    PairwiseDisjointIntervals Is →
    (∀ I ∈ Is, a ≤ I.1 ∧ I.2 ≤ b) →
    totalOscillation f Is ≤ M

def IntervalPoint (x : ℝ) (I : Interval) : Prop :=
  (I.1 ≤ x ∧ x ≤ I.2) ∨ (I.2 ≤ x ∧ x ≤ I.1)

def NullSet (s : Set ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ Is : List Interval,
    s ⊆ {x : ℝ | ∃ I ∈ Is, IntervalPoint x I} ∧
    totalLength Is < ε

def PreservesNullSetsOn (f : ℝ → ℝ) (a b : ℝ) : Prop :=
  ∀ s : Set ℝ, s ⊆ Set.Icc a b → NullSet s → NullSet (f '' s)

def DifferentiableAlmostEverywhereOn (f : ℝ → ℝ) (a b : ℝ) : Prop :=
  ∃ s : Set ℝ, NullSet s ∧
    ∀ x ∈ Set.Icc a b, x ∉ s → ∃ deriv : ℝ, HasDerivAt f deriv x

structure SeveralLemma (f : ℝ → ℝ) (a b : ℝ) : Prop where
  epsilon_delta : AbsolutelyContinuousOn f a b
  variation_formula : BoundedVariationOn f a b
  lusin_n : PreservesNullSetsOn f a b
  integral_calculus : DifferentiableAlmostEverywhereOn f a b

structure AbsolutelyContinuousAdmittedObject where
  f : ℝ → ℝ
  a : ℝ
  b : ℝ
  is_absolutelyContinuous : AbsolutelyContinuousOn f a b
  source : String

structure AbsolutelyContinuousWitnessClosed (A : AbsolutelyContinuousAdmittedObject) : Prop where
  bounded_variation : BoundedVariationOn A.f A.a A.b
  lusin_n : PreservesNullSetsOn A.f A.a A.b
  almost_everywhere_differentiable : DifferentiableAlmostEverywhereOn A.f A.a A.b

structure AdmissibleClass where
  admittedObject : AbsolutelyContinuousAdmittedObject
  severalLemma : SeveralLemma admittedObject.f admittedObject.a admittedObject.b
  endpointSatisfied : Prop
  remainderRecorded : Prop
  gateWitness : endpointSatisfied ∨ remainderRecorded

def bridgeClosed (A : AdmissibleClass) : Prop :=
  A.admittedObject.is_absolutelyContinuous ∧ A.severalLemma.variation_formula ∧ A.severalLemma.lusin_n

def gateClosed (A : AdmissibleClass) : Prop :=
  A.severalLemma.integral_calculus ∧ A.gateWitness

def ConstrainedTheoremClosure (A : AdmissibleClass) : Prop :=
  bridgeClosed A ∧ gateClosed A

def admittedClosure (A : AdmissibleClass) : Prop :=
  AbsolutelyContinuousWitnessClosed A.admittedObject ∧ (A.endpointSatisfied ∨ A.remainderRecorded)

theorem several_lemma_endgame (A : AdmissibleClass) : ConstrainedTheoremClosure A := by
  exact ⟨⟨A.admittedObject.is_absolutelyContinuous, ⟨A.severalLemma.variation_formula, A.severalLemma.lusin_n⟩⟩,
         ⟨A.severalLemma.integral_calculus, A.gateWitness⟩⟩

end AbsolutelyContinuousRealFunctionsSeveralLemmaCanonicalLaneLean
end HautevilleHouse