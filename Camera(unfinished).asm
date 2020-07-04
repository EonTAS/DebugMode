
!Camera Centre Display [Eon]
HOOK @ $80018de0 
{
    mr r3, r31
    lis r12, 0x8001
    ori r12, r12, 0x9768
    mtctr r12
    bctr
}