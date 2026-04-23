GetBaseData::
	push bc
	push de
	push hl
	ldh a, [hROMBank]
	push af

; Egg doesn't have BaseData
	ld a, [wCurSpecies]
	ld l, a
	ld a, [wCurSpecies + 1]
	ld h, a
	ld a, h
	or a
	jr nz, .get_base_data ; High byte != 0 means it's not an egg
	ld a, l
	cp EGG
	jr z, .egg

.get_base_data
; Get BaseData
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	ld a, BANK(BaseData)
	ld hl, BaseData
	call LoadIndirectPointer
	rst Bankswitch
	ld de, wCurBaseData
	ld bc, BASE_DATA_SIZE
	call CopyBytes
	jr .end

.egg
	; ld de, UnknownEggPic

; Sprite dimensions
	ld b, $55 ; 5x5
	ld hl, wBasePicSize
	ld [hl], b

	; ld hl, wBasePadding
	; ld [hl], e
	; inc hl
	; ld [hl], d
	; inc hl
	; ld [hl], e
	; inc hl
	; ld [hl], d
	; jr .end

.end
; Replace Pokedex # with species
	ld a, [wCurSpecies]
	ld [wBaseSpecies], a
	ld a, [wCurSpecies + 1]
	ld [wBaseSpecies + 1], a

	pop af
	rst Bankswitch
	pop hl
	pop de
	pop bc
	ret

GetCurNick::
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames

GetNick::
; Get nickname a from list hl.

	push hl
	push bc

	call SkipNames
	ld de, wStringBuffer1

	push de
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	pop de

	callfar CorrectNickErrors

	pop bc
	pop hl
	ret
