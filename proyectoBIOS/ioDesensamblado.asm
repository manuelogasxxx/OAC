io.o:     file format elf32-i386


Disassembly of section .text:

00000000 <proc_nwln>:
   0:   60                      pusha
   1:   b8 04 00 00 00          mov    $0x4,%eax
   6:   bb 01 00 00 00          mov    $0x1,%ebx
   b:   b9 00 00 00 00          mov    $0x0,%ecx
  10:   ba 01 00 00 00          mov    $0x1,%edx
  15:   cd 80                   int    $0x80
  17:   61                      popa
  18:   c3                      ret

00000019 <proc_PutCh>:
  19:   60                      pusha
  1a:   a2 00 00 00 00          mov    %al,0x0
  1f:   b8 04 00 00 00          mov    $0x4,%eax
  24:   bb 01 00 00 00          mov    $0x1,%ebx
  29:   b9 00 00 00 00          mov    $0x0,%ecx
  2e:   ba 01 00 00 00          mov    $0x1,%edx
  33:   cd 80                   int    $0x80
  35:   61                      popa
  36:   c3                      ret

00000037 <proc_PutStr>:
  37:   60                      pusha
  38:   9c                      pushf
  39:   bb 01 00 00 00          mov    $0x1,%ebx
  3e:   ba 01 00 00 00          mov    $0x1,%edx

00000043 <proc_PutStr.rpt_putstr>:
  43:   b8 04 00 00 00          mov    $0x4,%eax
  48:   80 39 00                cmpb   $0x0,(%ecx)
  4b:   74 05                   je     52 <proc_PutStr.skip_putstr>
  4d:   cd 80                   int    $0x80
  4f:   41                      inc    %ecx
  50:   eb f1                   jmp    43 <proc_PutStr.rpt_putstr>

00000052 <proc_PutStr.skip_putstr>:
  52:   9d                      popf
  53:   61                      popa
  54:   c3                      ret

00000055 <proc_GetStr>:
  55:   60                      pusha
  56:   9c                      pushf
  57:   b8 03 00 00 00          mov    $0x3,%eax
  5c:   bb 00 00 00 00          mov    $0x0,%ebx
  61:   b9 01 00 00 00          mov    $0x1,%ecx
  66:   ba 00 01 00 00          mov    $0x100,%edx
  6b:   cd 80                   int    $0x80
  6d:   89 f1                   mov    %esi,%ecx
  6f:   49                      dec    %ecx
  70:   89 fb                   mov    %edi,%ebx
  72:   be 01 00 00 00          mov    $0x1,%esi

00000077 <proc_GetStr.loop_getstr>:
  77:   8a 06                   mov    (%esi),%al
  79:   3c 0a                   cmp    $0xa,%al
  7b:   74 06                   je     83 <proc_GetStr.done_getstr>
  7d:   88 03                   mov    %al,(%ebx)
  7f:   43                      inc    %ebx
  80:   46                      inc    %esi
  81:   e2 f4                   loop   77 <proc_GetStr.loop_getstr>

00000083 <proc_GetStr.done_getstr>:
  83:   c6 03 00                movb   $0x0,(%ebx)
  86:   9d                      popf
  87:   61                      popa
  88:   c3                      ret

00000089 <proc_GetCh>:
  89:   9c                      pushf
  8a:   60                      pusha
  8b:   b8 03 00 00 00          mov    $0x3,%eax
  90:   bb 00 00 00 00          mov    $0x0,%ebx
  95:   b9 00 00 00 00          mov    $0x0,%ecx
  9a:   ba 00 01 00 00          mov    $0x100,%edx
  9f:   cd 80                   int    $0x80
  a1:   61                      popa
  a2:   66 81 fe 01 00          cmp    $0x1,%si
  a7:   75 0b                   jne    b4 <proc_GetCh.skip_getch>
  a9:   8a 25 00 00 00 00       mov    0x0,%ah
  af:   e9 05 00 00 00          jmp    b9 <proc_GetCh.done_getch>

000000b4 <proc_GetCh.skip_getch>:
  b4:   a0 00 00 00 00          mov    0x0,%al

000000b9 <proc_GetCh.done_getch>:
  b9:   9d                      popf
  ba:   c3                      ret

000000bb <proc_PutInt>:
  bb:   60                      pusha
  bc:   be 01 01 00 00          mov    $0x101,%esi
  c1:   c6 06 20                movb   $0x20,(%esi)
  c4:   66 3d 00 00             cmp    $0x0,%ax
  c8:   7d 06                   jge    d0 <proc_PutInt.pi_positive>
  ca:   c6 06 2d                movb   $0x2d,(%esi)
  cd:   66 f7 d8                neg    %ax

000000d0 <proc_PutInt.pi_positive>:
  d0:   66 bb 0a 00             mov    $0xa,%bx
  d4:   81 c6 06 00 00 00       add    $0x6,%esi
  da:   c6 06 00                movb   $0x0,(%esi)
  dd:   4e                      dec    %esi
  de:   66 b9 05 00             mov    $0x5,%cx

000000e2 <proc_PutInt.putint_repeat>:
  e2:   66 ba 00 00             mov    $0x0,%dx
  e6:   66 f7 f3                div    %bx
  e9:   80 c2 30                add    $0x30,%dl
  ec:   88 16                   mov    %dl,(%esi)
  ee:   4e                      dec    %esi
  ef:   66 49                   dec    %cx
  f1:   66 3d 00 00             cmp    $0x0,%ax
  f5:   75 eb                   jne    e2 <proc_PutInt.putint_repeat>
  f7:   67 e3 0e                jcxz   108 <proc_PutInt.pi_write_number>
  fa:   8a 1d 01 01 00 00       mov    0x101,%bl
 100:   88 1e                   mov    %bl,(%esi)
 102:   80 fb 20                cmp    $0x20,%bl
 105:   75 01                   jne    108 <proc_PutInt.pi_write_number>
 107:   46                      inc    %esi

00000108 <proc_PutInt.pi_write_number>:
 108:   89 f1                   mov    %esi,%ecx
 10a:   e8 28 ff ff ff          call   37 <proc_PutStr>
 10f:   61                      popa
 110:   c3                      ret

00000111 <proc_GetInt>:
 111:   53                      push   %ebx
 112:   51                      push   %ecx
 113:   52                      push   %edx
 114:   56                      push   %esi
 115:   57                      push   %edi
 116:   9c                      pushf

00000117 <proc_GetInt.read_input>:
 117:   be 00 01 00 00          mov    $0x100,%esi
 11c:   bf 01 01 00 00          mov    $0x101,%edi
 121:   e8 2f ff ff ff          call   55 <proc_GetStr>
 126:   be 01 01 00 00          mov    $0x101,%esi
 12b:   4e                      dec    %esi

0000012c <proc_GetInt.skip_blanks>:
 12c:   46                      inc    %esi
 12d:   80 3e 20                cmpb   $0x20,(%esi)
 130:   74 fa                   je     12c <proc_GetInt.skip_blanks>
 132:   89 f7                   mov    %esi,%edi

00000134 <proc_GetInt.non_blanks>:
 134:   b9 07 00 00 00          mov    $0x7,%ecx
 139:   8a 06                   mov    (%esi),%al
 13b:   3c 2b                   cmp    $0x2b,%al
 13d:   74 0c                   je     14b <proc_GetInt.valid_char>
 13f:   3c 2d                   cmp    $0x2d,%al
 141:   74 08                   je     14b <proc_GetInt.valid_char>

00000143 <proc_GetInt.test_next_char>:
 143:   3c 30                   cmp    $0x30,%al
 145:   72 29                   jb     170 <proc_GetInt.invalid_char>
 147:   3c 39                   cmp    $0x39,%al
 149:   77 25                   ja     170 <proc_GetInt.invalid_char>

0000014b <proc_GetInt.valid_char>:
 14b:   46                      inc    %esi
 14c:   49                      dec    %ecx
 14d:   67 e3 04                jcxz   154 <proc_GetInt.out_of_range>
 150:   8a 06                   mov    (%esi),%al
 152:   eb ef                   jmp    143 <proc_GetInt.test_next_char>

00000154 <proc_GetInt.out_of_range>:
 154:   51                      push   %ecx
 155:   b9 01 00 00 00          mov    $0x1,%ecx
 15a:   e8 d8 fe ff ff          call   37 <proc_PutStr>
 15f:   59                      pop    %ecx
 160:   eb b5                   jmp    117 <proc_GetInt.read_input>

00000162 <proc_GetInt.no_input>:
 162:   51                      push   %ecx
 163:   b9 42 00 00 00          mov    $0x42,%ecx
 168:   e8 ca fe ff ff          call   37 <proc_PutStr>
 16d:   59                      pop    %ecx
 16e:   eb a7                   jmp    117 <proc_GetInt.read_input>

00000170 <proc_GetInt.invalid_char>:
 170:   c6 06 00                movb   $0x0,(%esi)
 173:   81 f9 07 00 00 00       cmp    $0x7,%ecx
 179:   74 e7                   je     162 <proc_GetInt.no_input>
 17b:   89 fe                   mov    %edi,%esi
 17d:   31 c0                   xor    %eax,%eax
 17f:   31 c9                   xor    %ecx,%ecx
 181:   66 bb 0a 00             mov    $0xa,%bx
 185:   8a 0e                   mov    (%esi),%cl
 187:   80 f9 2d                cmp    $0x2d,%cl
 18a:   74 05                   je     191 <proc_GetInt.incSI>
 18c:   80 f9 2b                cmp    $0x2b,%cl
 18f:   75 01                   jne    192 <proc_GetInt.convert_loop>

00000191 <proc_GetInt.incSI>:
 191:   46                      inc    %esi

00000192 <proc_GetInt.convert_loop>:
 192:   8a 0e                   mov    (%esi),%cl
 194:   80 f9 00                cmp    $0x0,%cl
 197:   74 16                   je     1af <proc_GetInt.conv_done>
 199:   80 e9 30                sub    $0x30,%cl
 19c:   66 f7 e3                mul    %bx
 19f:   72 b3                   jb     154 <proc_GetInt.out_of_range>
 1a1:   66 01 c8                add    %cx,%ax
 1a4:   72 ae                   jb     154 <proc_GetInt.out_of_range>
 1a6:   66 3d 00 80             cmp    $0x8000,%ax
 1aa:   77 a8                   ja     154 <proc_GetInt.out_of_range>
 1ac:   46                      inc    %esi
 1ad:   eb e3                   jmp    192 <proc_GetInt.convert_loop>

000001af <proc_GetInt.conv_done>:
 1af:   89 fe                   mov    %edi,%esi
 1b1:   8a 0e                   mov    (%esi),%cl
 1b3:   66 81 fa 00 00          cmp    $0x0,%dx
 1b8:   75 9a                   jne    154 <proc_GetInt.out_of_range>
 1ba:   66 3d 00 80             cmp    $0x8000,%ax
 1be:   72 05                   jb     1c5 <proc_GetInt.number_OK>
 1c0:   80 f9 2d                cmp    $0x2d,%cl
 1c3:   75 8f                   jne    154 <proc_GetInt.out_of_range>

000001c5 <proc_GetInt.number_OK>:
 1c5:   80 f9 2d                cmp    $0x2d,%cl
 1c8:   75 03                   jne    1cd <proc_GetInt.num_done>
 1ca:   66 f7 d8                neg    %ax

000001cd <proc_GetInt.num_done>:
 1cd:   9d                      popf
 1ce:   5f                      pop    %edi
 1cf:   5e                      pop    %esi
 1d0:   5a                      pop    %edx
 1d1:   59                      pop    %ecx
 1d2:   5b                      pop    %ebx
 1d3:   c3                      ret

000001d4 <proc_PutLInt>:
 1d4:   60                      pusha
 1d5:   be 01 01 00 00          mov    $0x101,%esi
 1da:   c6 06 20                movb   $0x20,(%esi)
 1dd:   3d 00 00 00 00          cmp    $0x0,%eax
 1e2:   7d 05                   jge    1e9 <proc_PutLInt.pli_positive>
 1e4:   c6 06 2d                movb   $0x2d,(%esi)
 1e7:   f7 d8                   neg    %eax

000001e9 <proc_PutLInt.pli_positive>:
 1e9:   bb 0a 00 00 00          mov    $0xa,%ebx
 1ee:   81 c6 0b 00 00 00       add    $0xb,%esi
 1f4:   c6 06 00                movb   $0x0,(%esi)
 1f7:   4e                      dec    %esi
 1f8:   b9 0a 00 00 00          mov    $0xa,%ecx

000001fd <proc_PutLInt.putLint_repeat>:
 1fd:   ba 00 00 00 00          mov    $0x0,%edx
 202:   f7 f3                   div    %ebx
 204:   80 c2 30                add    $0x30,%dl
 207:   88 16                   mov    %dl,(%esi)
 209:   4e                      dec    %esi
 20a:   49                      dec    %ecx
 20b:   3d 00 00 00 00          cmp    $0x0,%eax
 210:   75 eb                   jne    1fd <proc_PutLInt.putLint_repeat>
 212:   67 e3 0e                jcxz   223 <proc_PutLInt.pli_write_number>
 215:   8a 1d 01 01 00 00       mov    0x101,%bl
 21b:   88 1e                   mov    %bl,(%esi)
 21d:   80 fb 20                cmp    $0x20,%bl
 220:   75 01                   jne    223 <proc_PutLInt.pli_write_number>
 222:   46                      inc    %esi

00000223 <proc_PutLInt.pli_write_number>:
 223:   89 f1                   mov    %esi,%ecx
 225:   e8 0d fe ff ff          call   37 <proc_PutStr>
 22a:   61                      popa
 22b:   c3                      ret

0000022c <proc_GetLInt>:
 22c:   53                      push   %ebx
 22d:   51                      push   %ecx
 22e:   52                      push   %edx
 22f:   56                      push   %esi
 230:   57                      push   %edi
 231:   9c                      pushf

00000232 <proc_GetLInt.read_L_input>:
 232:   be 00 01 00 00          mov    $0x100,%esi
 237:   bf 01 01 00 00          mov    $0x101,%edi
 23c:   e8 14 fe ff ff          call   55 <proc_GetStr>
 241:   be 01 01 00 00          mov    $0x101,%esi
 246:   4e                      dec    %esi

00000247 <proc_GetLInt.skip_L_blanks>:
 247:   46                      inc    %esi
 248:   80 3e 20                cmpb   $0x20,(%esi)
 24b:   74 fa                   je     247 <proc_GetLInt.skip_L_blanks>
 24d:   89 f7                   mov    %esi,%edi

0000024f <proc_GetLInt.non_L_blanks>:
 24f:   b9 0c 00 00 00          mov    $0xc,%ecx
 254:   8a 06                   mov    (%esi),%al
 256:   3c 2b                   cmp    $0x2b,%al
 258:   74 0c                   je     266 <proc_GetLInt.valid_L_char>
 25a:   3c 2d                   cmp    $0x2d,%al
 25c:   74 08                   je     266 <proc_GetLInt.valid_L_char>

0000025e <proc_GetLInt.test_next_L_char>:
 25e:   3c 30                   cmp    $0x30,%al
 260:   72 2b                   jb     28d <proc_GetLInt.invalid_L_char>
 262:   3c 39                   cmp    $0x39,%al
 264:   77 27                   ja     28d <proc_GetLInt.invalid_L_char>

00000266 <proc_GetLInt.valid_L_char>:
 266:   66 46                   inc    %si
 268:   66 49                   dec    %cx
 26a:   67 e3 04                jcxz   271 <proc_GetLInt.out_of_L_range>
 26d:   8a 06                   mov    (%esi),%al
 26f:   eb ed                   jmp    25e <proc_GetLInt.test_next_L_char>

00000271 <proc_GetLInt.out_of_L_range>:
 271:   51                      push   %ecx
 272:   b9 6d 00 00 00          mov    $0x6d,%ecx
 277:   e8 bb fd ff ff          call   37 <proc_PutStr>
 27c:   59                      pop    %ecx
 27d:   eb b3                   jmp    232 <proc_GetLInt.read_L_input>

0000027f <proc_GetLInt.no_L_input>:
 27f:   51                      push   %ecx
 280:   b9 42 00 00 00          mov    $0x42,%ecx
 285:   e8 ad fd ff ff          call   37 <proc_PutStr>
 28a:   59                      pop    %ecx
 28b:   eb a5                   jmp    232 <proc_GetLInt.read_L_input>

0000028d <proc_GetLInt.invalid_L_char>:
 28d:   c6 06 00                movb   $0x0,(%esi)
 290:   81 f9 0c 00 00 00       cmp    $0xc,%ecx
 296:   74 e7                   je     27f <proc_GetLInt.no_L_input>
 298:   89 fe                   mov    %edi,%esi
 29a:   31 c0                   xor    %eax,%eax
 29c:   31 c9                   xor    %ecx,%ecx
 29e:   bb 0a 00 00 00          mov    $0xa,%ebx
 2a3:   8a 0e                   mov    (%esi),%cl
 2a5:   80 f9 2d                cmp    $0x2d,%cl
 2a8:   74 05                   je     2af <proc_GetLInt.L_incSI>
 2aa:   80 f9 2b                cmp    $0x2b,%cl
 2ad:   75 01                   jne    2b0 <proc_GetLInt.L_convert_loop>

000002af <proc_GetLInt.L_incSI>:
 2af:   46                      inc    %esi

000002b0 <proc_GetLInt.L_convert_loop>:
 2b0:   8a 0e                   mov    (%esi),%cl
 2b2:   80 f9 00                cmp    $0x0,%cl
 2b5:   74 15                   je     2cc <proc_GetLInt.L_conv_done>
 2b7:   80 e9 30                sub    $0x30,%cl
 2ba:   f7 e3                   mul    %ebx
 2bc:   72 b3                   jb     271 <proc_GetLInt.out_of_L_range>
 2be:   01 c8                   add    %ecx,%eax
 2c0:   72 af                   jb     271 <proc_GetLInt.out_of_L_range>
 2c2:   3d 00 00 00 80          cmp    $0x80000000,%eax
 2c7:   77 a8                   ja     271 <proc_GetLInt.out_of_L_range>
 2c9:   46                      inc    %esi
 2ca:   eb e4                   jmp    2b0 <proc_GetLInt.L_convert_loop>

000002cc <proc_GetLInt.L_conv_done>:
 2cc:   89 fe                   mov    %edi,%esi
 2ce:   8a 0e                   mov    (%esi),%cl
 2d0:   81 fa 00 00 00 00       cmp    $0x0,%edx
 2d6:   75 99                   jne    271 <proc_GetLInt.out_of_L_range>
 2d8:   3d 00 00 00 80          cmp    $0x80000000,%eax
 2dd:   72 05                   jb     2e4 <proc_GetLInt.L_number_OK>
 2df:   80 f9 2d                cmp    $0x2d,%cl
 2e2:   75 8d                   jne    271 <proc_GetLInt.out_of_L_range>

000002e4 <proc_GetLInt.L_number_OK>:
 2e4:   80 f9 2d                cmp    $0x2d,%cl
 2e7:   75 02                   jne    2eb <proc_GetLInt.L_num_done>
 2e9:   f7 d8                   neg    %eax

000002eb <proc_GetLInt.L_num_done>:
 2eb:   9d                      popf
 2ec:   5f                      pop    %edi
 2ed:   5e                      pop    %esi
 2ee:   5a                      pop    %edx
 2ef:   59                      pop    %ecx
 2f0:   5b                      pop    %ebx
 2f1:   c3                      ret