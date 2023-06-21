using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MatrixExample : MonoBehaviour
{

    // Start is called before the first frame update
    void Start()
    {
        Debug.Log(transform.position);
        Debug.Log(transform.localPosition);

        Matrix4x4 modelMatrix = transform.parent.localToWorldMatrix;

        Debug.Log(modelMatrix.MultiplyPoint(transform.localPosition));

    }
}
