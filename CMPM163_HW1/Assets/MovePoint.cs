using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovePoint : MonoBehaviour
{
    private Vector3 StartPos;
    private float ElapsedTime = 0f;
    // Start is called before the first frame update
    void Start()
    {
        StartPos = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        ElapsedTime += Time.deltaTime;
        //transform.position.x = StartPos.x + Mathf.Sin(Time.deltaTime * Mathf.PI);
        Vector3 newPos = StartPos;
        newPos.x += Mathf.Sin(ElapsedTime);

        transform.position = newPos;
    }
}
