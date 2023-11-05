Invoke-WebRequest -Uri "https://docs.google.com/uc?export=download&id=1PbQQ4p2jAoFUQWZRDgsR-PPBgxYxuqsZ" -OutFile "$dir\image.png"
Set-WallPaper -Image "$dir\image.png" -Style Fit
