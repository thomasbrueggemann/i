# 🙂 Ich
Digital multi-dimensional data representation of myself.

## Intro

At any point in **time** I am (in the foreseeable future) **somewhere** on earth, doing **something**. Therefore the main datamodel for _ich_ is:

```json
{
  "time": new Date(),
  "loc":  {
	  "type": "Point",
	  "coordinates": [ -73.97, 40.77 ]
  },
  "data: {
	  // ...
  }
}
```
