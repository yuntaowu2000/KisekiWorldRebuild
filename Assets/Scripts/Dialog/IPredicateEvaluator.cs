using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IPredicateEvaluator
{
    //? makes the return value nullable
    bool? Evaluate(string predicate, string[] parameters);
}