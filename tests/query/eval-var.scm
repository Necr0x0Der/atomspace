;
; Unit test for evaluation of variables
;
(use-modules (opencog))
(use-modules (opencog query))

(define (truf x)
	(cond
		((equal? x (ConceptNode "good")) (cog-new-stv 1 1))
		((equal? x (ConceptNode "bad")) (cog-new-stv 0 1))
		(else (throw 'whats-up-jack "you done it wrong"))
	)
)

(define (konsekwens x)
	(ImplicationLink x)
)

; The bind link will accept this
(ContextLink
	(ConceptNode "situation")
	(EvaluationLink
		(GroundedPredicateNode "scm: truf")
		(ListLink (ConceptNode "good"))
	)
	(ExecutionOutputLink
		(GroundedSchemaNode "scm: konsekwens")
		(ListLink (ConceptNode "acceptance"))
	)
)

; The bind link will reject this
(ContextLink
	(ConceptNode "predicament")
	(EvaluationLink
		(GroundedPredicateNode "scm: truf")
		(ListLink (ConceptNode "bad"))
	)
	(ExecutionOutputLink
		(GroundedSchemaNode "scm: konsekwens")
		(ListLink (ConceptNode "rejection"))
	)
)

; This pattern will accept one of the two above, reject the other.
(define (do-things)
	(BindLink
		(VariableList
			(VariableNode "$cxt")
			(VariableNode "$condition")
			(VariableNode "$action")
		)
		(ImplicationLink
			(AndLink
				; If there is a plan ...
				(ContextLink
					(VariableNode "$cxt")
					(VariableNode "$condition")
					(VariableNode "$action")
				)
				; ... and the precondition holds true ...
				(VariableNode "$condition")
			)
			; ...  then perform the action.
			(VariableNode "$action")
		)
	)
)