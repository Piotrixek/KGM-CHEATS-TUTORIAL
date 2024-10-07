{
  Version: 1.1
  Date   : 2024-10-06
  Author : Veni
}

define(hook,"MVAvatarLocal.FixedUpdate")
define(bytes,55 8B EC 8B 45 08)

[enable]

assert(hook, bytes)
alloc(newmem,$1000, hook)


newmem:
push ebp
mov ebp, esp
sub esp, 0x20
mov eax,[GameAssembly.dll+1B0FFDC] // object !!! important
mov edi, dword [ebp+0x8]
mov esi, dword [edi+0x88]


push [GameAssembly.dll+1B314A0]
push esi
call GameAssembly.dll+72DD50
mov ebx, eax // player to ebx as a parameter to call
add esp, 0x8
mov [ebp-04],ebx


push 0x0 // first param
push ebx // player [second parameter]
call UnityEngine.GameObject.get_transform //2 parameters
add esp, 0x8 // 2 params


push 00
push ebx // result , will be putted as a parameter of call
call UnityEngine.GameObject.get_transform // ebx param which is last result
// we called again UnityEngine.GameObject.get_transform so we will put it as a next call shit.
//   eax_1 = GameAssembly.dll+72DD50(var_38, var_34_2)
//   result_1 = eax_1
//  var_4c_1 = result_1
// example:     eax_4 = UnityEngine.GameObject.get_transform(var_4c_1)
//   var_38_2 = eax_4
//   var_3c_2 = &var_18
//   eax_5 = UnityEngine.Transform.get_position(var_3c_2, var_38_2)
// you see what i mean. Type shit
add esp,08

push 0x0
push eax //  eax_4 = UnityEngine.GameObject.get_transform(var_4c_1)
lea eax,[ebp-0x14]
push eax
call UnityEngine.Transform.get_position
add esp,0C

mov eax,[ebp-04]
pop edi
pop esi
pop ebx
mov esp,ebp
pop ebp
ret
  // original code
  push ebp
  mov ebp,esp
  mov eax,[ebp+08]
  jmp hook+6

hook:
  jmp newmem

[disable]

hook:
  db bytes

dealloc(newmem)

