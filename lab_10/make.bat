\masm32\bin\ml /c /coff /Cp main.asm 
\masm32\bin\rc rsrc.rc
\masm32\bin\link /subsystem:windows main.obj rsrc.res
del main.obj
del rsrc.res
pause