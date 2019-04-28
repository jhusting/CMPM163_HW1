using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClickScript : MonoBehaviour
{
    Renderer r;

    private float val = 0;
    // Start is called before the first frame update
    void Start()
    {
        r = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnMouseOver()
    {
        if(Input.GetMouseButtonDown(0))
        {
            val += 6f;

            val %= 18f;

            r.material.SetFloat("_Steps", val);
        }
    }
}
