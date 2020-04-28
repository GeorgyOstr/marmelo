/*
	mod_NINI
	
	author : motchy
*/

#ifndef FALSE
	#define global	FALSE	0
#endif
#ifndef TRUE
	#define global	TRUE	1
#endif

#define global MAX_LEN_SECTION_NAME	127
#define global MAX_LEN_KEY_NAME	127

#module mv_nini txt,curDepth,curSectName,count
	id=0
	#modinit str txt_
		txt=txt_
		curDepth=0
		curSectName="body"
		count=0	//�J�E���^�B��Ɍ��݂̃Z�N�V������"<"�̍����ɂ���B
		mref id,2
		return id
	#modcfunc local getText
		return txt
	#modcfunc local getCurLine	//���݃J�E���^�̂���s���擾����
		tmp=strmid(txt,0,count) : strrep tmp, "\n","\n"
		return stat
	#modcfunc local existSection str sectionName_
		if (sectionName_=="!") {return 0}
		selSection thismod,sectionName_
		if (stat) {return 0}
		goUp thismod
		return 1
	#modfunc local enumSections array list_
		count_enum=0
		depth2=0	//���݈ʒu��̑��ΐ[��
		count2=count
		repeat
			buf=peek(txt,count2) : count2++
			if (buf=='<') {	//<>�̒��g��ǂ݂Ȃ���Ή�����">"��T��
				buf=peek(txt,count2) : count2++
				if (buf=='/') {depth2--} else {depth2++}
				sdim buf2,MAX_LEN_SECTION_NAME+1 : poke buf2, 0, buf : len_buf2=1
				repeat
					buf=peek(txt,count2) : count2++
					if (buf=='>') {break}
					poke buf2, len_buf2, buf : len_buf2++
				loop
				if ((depth2==2)&&(peek(buf2,0)!='!')&&(peek(buf2,0)!='/')) {list_(count_enum)=buf2 : count_enum++}
				if (depth2==0) {break}
			}
		loop
		return count_enum
	#modfunc local selSection str sectionName_
		depth2=0
		count2=count
		flg_found=0
		repeat
			buf=peek(txt,count2) : count2++
			if (buf=='<') {	//<>�̒��g��ǂ݂Ȃ���Ή�����">"��T��
				buf=peek(txt,count2) : count2++
				if (buf=='/') {depth2--} else {depth2++}
				sdim buf2,MAX_LEN_SECTION_NAME+1 : poke buf2, 0, buf : len_buf2=1
				repeat
					buf=peek(txt,count2) : count2++
					if (buf=='>') {break}
					poke buf2, len_buf2, buf : len_buf2++
				loop
				if ((depth2==2)&&(buf2==sectionName_)) {flg_found=1 : break}
				if (depth2==0) {break}
			}
		loop
		if (flg_found==0) {return 1}
		count=count2-2-strlen(sectionName_)
		curDepth++
		curSectName=sectionName_
		return 0
	#modcfunc local getCurDepth
		return curDepth
	#modfunc local goUp
		if (curDepth==0) {return 1}
		count2=count-1
		depth2=0	//���݈ʒu��̑��ΐ[��
		repeat	//�������ɓǂ�
			buf=peek(txt,count2) : count2--
			if (buf=='>') {	//�Ή�����"<"��T��
				repeat
					buf=peek(txt,count2) : count2--
					if (buf=='<') {
						if (peek(txt,count2+2)=='/') {depth2++} else {depth2--}
						break
					}
				loop
				if (depth2==-1) {break}
			}
		loop
		count=count2+1
		curDepth--
		/* �Z�N�V���������擾 */
			getstr curSectName, txt, count+1,'>'
		return 0
	#modcfunc local getEndOfCurSection	//�I�𒆂̃Z�N�V�����ɑΉ�����"</"�̈ʒu��Ԃ�
		depth2=0
		count2=count
		repeat
			buf=peek(txt,count2) : count2++
			if (buf=='<') {	//�Ή�����">"��T��
				if (peek(txt,count2)=='/') {depth2--} else {depth2++}
				repeat
					buf=peek(txt,count2) : count2++
					if (buf=='>') {break}
				loop
				if (depth2==0) {break}
			}
		loop
		return count2-3-strlen(curSectName)
	#modfunc local newSection str sectionName_
		buf=sectionName_
		if (existSection(thismod,sectionName_)|(peek(buf,0)=='!')) {return 1}
		sep=getEndOfCurSection(thismod)-curDepth
		/* �Z�N�V�����}�� */
			txt2=strmid(txt,sep,strlen(txt)-sep) : txt=strmid(txt,0,sep)	//�㔼,�O��
			repeat curDepth+1 : txt+="	" : loop	//Tab
			txt+="<"+sectionName_+">"+"\n"
			repeat curDepth+1 : txt+="	" : loop	//Tab
			txt+="</"+sectionName_+">"+"\n"
			txt+=txt2
		return 0
	#modfunc local delCurSection
		if (curDepth==0) : return 1
		c1=count-curDepth : c2=getEndOfCurSection(thismod)+3+strlen(curSectName)+2	//+2:���s�R�[�h
		goUp thismod
		txt=strmid(txt,0,c1)+strmid(txt,c2,strlen(txt)-c2)
		return 0
	#modcfunc local getStartOfKey str keyName_	//�w�肳�ꂽ�L�[��T���A����΂��̈ʒu��,�Ȃ����-1��Ԃ��B
		depth2=0
		count2=count
		flg_found=0
		repeat
			buf=peek(txt,count2) : count2++
			if (buf=='<') {	//�Ή�����">"��T��
				if (peek(txt,count2)=='/') {depth2--} else {depth2++}
				repeat
					buf=peek(txt,count2) : count2++
					if (buf=='>') {break}
				loop
				if (depth2==0) {break}
			} else {
				if ((depth2==1)&&(buf=='=')) {	//�Ή�����L�[��buf2�ɓǂݏo��
					count3=count2-2 : sdim buf2,MAX_LEN_KEY_NAME+1 : len_buf2=0
					repeat	//�������ɓǂ�
						buf=peek(txt,count3) : count3--
						if (buf=='	') {	//Tab�ɂԂ�������(���L�[�̍��ɂ͕K��Tab������)
							if (buf2==keyName_) : flg_found=1
							break
						}
						memcpy buf2,buf2, len_buf2, 1,0 : poke buf2, 0, buf : len_buf2++
					loop
					if (flg_found) {break}
				}
			}
		loop
		if (flg_found==0) {return -1}
		return count3+2
	#modcfunc local existKey str keyName_
		return limit(getStartOfKey(thismod,keyName_),0,1)
	#modfunc local emumKeys	array list_
		depth2=0
		count2=count
		count_enum=0
		repeat
			buf=peek(txt,count2) : count2++
			if (buf=='<') {	//�Ή�����">"��T��
				if (peek(txt,count2)=='/') {depth2--} else {depth2++}
				repeat
					buf=peek(txt,count2) : count2++
					if (buf=='>') {break}
				loop
				if (depth2==0) {break}
			} else {
				if ((depth2==1)&&(buf=='=')) {	//�Ή�����L�[��buf2�ɓǂݏo��
					count3=count2-2 : sdim buf2,MAX_LEN_KEY_NAME+1 : len_buf2=0
					repeat	//�������ɓǂ�
						buf=peek(txt,count3) : count3--
						if (buf=='	') {	//Tab�ɂԂ�������(���L�[�̍��ɂ͕K��Tab������)
							list_(count_enum)=buf2 : count_enum++
							break
						}
						memcpy buf2,buf2, len_buf2, 1,0 : poke buf2, 0, buf : len_buf2++
					loop
				}
			}
		loop
		return count_enum
	#modfunc local newKey str keyName_, str val_
		if (existKey(thismod,keyName_)) {return 1}
		sep=getEndOfCurSection(thismod)-curDepth
		/* �L�[�}�� */
			txt2=strmid(txt,sep,strlen(txt)-sep) : txt=strmid(txt,0,sep)	//�㔼,�O��
			repeat curDepth+1 : txt+="	" : loop	//Tab
			txt+=keyName_+"="+val_+"\n"
			txt+=txt2
		return 0
	#modfunc local delKey str keyName_
		c1=getStartOfKey(thismod,keyName_) : if (c1==-1) : return 1
		c2=c1+instr(txt,c1,"=")+1
		count2=c2
		repeat	//�l�̏I����T���B�E���̃R�����g��������B
			buf=peek(txt,count2) : count2++
			if (buf==13) {if (peek(txt,count2)==10) {break}}
		loop
		c2=c1-curDepth-1 : c3=count2+1
		txt=strmid(txt,0,c2)+strmid(txt,c3,strlen(txt)-c3)
		return 0
	#modcfunc local getVal str keyName_, str default_
		c1=getStartOfKey(thismod,keyName_) : if (c1==-1) : return default_
		c2=c1+instr(txt,c1,"=")+1	//�l�̎n�܂�
		count2=c2
		repeat	//�l�̏I����T��
			buf=peek(txt,count2) : count2++
			if (buf==13) {if (peek(txt,count2)==10) {break}}
			if (buf=='<') {break}
		loop
		return strmid(txt,c2,count2-1-c2)
	#modfunc local setVal str keyName_, str val_
		c1=getStartOfKey(thismod,keyName_) : if (c1==-1) : return 1
		c1+=instr(txt,c1,"=")+1	//�l�̎n�܂�
		repeat	//�l�̏I����T��
			buf=peek(txt,count2) : count2++
			if (buf==13) {if (peek(txt,count2)==10) {break}}
			if (buf=='<') {break}
		loop : c2=count2-1
		txt=strmid(txt,0,c1)+val_+strmid(txt,c2,strlen(txt)-c2)
		return 0
#global

#module mod_nini_inspect
	#defcfunc nini_isValidNini str nini_, var errLine_	//nini�f�[�^�̌���
		/*
			(in) nini_ : nini�f�[�^
			(in) errLine_ : �G���[�������ɂ��̕ϐ��ɂ��̍s�ԍ����ۑ������
		*/
		nini=nini_
		len_nini=strlen(nini) : if (len_nini<strlen("<body>\n</body>")) {return FALSE}
		if (strmid(nini,0,strlen("<body>"))!="<body>") {return FALSE}	//<body>�Ŏn�܂�Ȃ��Ă͂Ȃ�Ȃ�
		nini+="abcde"	//�I�[�o�[���[�h�ɔ�����
		//���R�����g������ȃZ�N�V�����Ƃ��Ĉ���
		count=strlen("<body>")	//���݂܂łɓǂݐi�߂��o�C�g��
		depthSect=1	//���݂̃Z�N�V�����[�x
		offsetFromLineHead=count	//�s������̃o�C�g��
		cntTabFromLineHead=0	//�s�������Tab��
		sectStack="body" : cntSectStack=1	//�Z�N�V�����X�^�b�N
		sdim bufToken,strlen(nini) : len_token=0	//�g�[�N���o�b�t�@
		/* ���҂���Ă���g�[�N���̎�� */
			#define TTE_SECTNAME	0
			#define TTE_KEY			1
			#define TTE_VAL			2
			#define TTE_COMMENT		4
			tte=TTE_KEY|TTE_VAL
		flg_broken=FALSE
		repeat
			if (count>=len_nini) {break}
			byte=peek(nini,count) : count++
			switch byte
				case '<'
					if (tte==TTE_SECTNAME) {flg_broken=TRUE : break}
					resetToken
					tte=TTE_SECTNAME
				swbreak
				case '>'
					if (tte!=TTE_SECTNAME) {flg_broken=TRUE : break}
					if (len_token==0) {flg_broken=TRUE : break}
					repeat 1
						if (bufToken=="!") {	//�R�����g�J�n
							sectStack(cntSectStack)="!" : cntSectStack++
							depthSect++
							tte=TTE_COMMENT
							break
						}
						if (peek(bufToken,0)=='/') {	//�Z�N�V�����̏I���
							bufToken_term=strtrim(bufToken,1,'/')
							if (bufToken_term!=sectStack(cntSectStack-1)) {flg_broken=TRUE : break}
							if (bufToken_term!="!") {	//�R�����g�łȂ��Ȃ�
								if (cntTabFromLineHead!=depthSect-1) {flg_broken=TRUE : break}
							}
							cntSectStack--
							depthSect--
							break
						}
						/* �Z�N�V�����̊J�n */
							if (cntTabFromLineHead!=depthSect) {flg_broken=TRUE : break}
							sectStack(cntSectStack)=bufToken : cntSectStack++
							depthSect++
					loop
					resetToken
					tte=TTE_KEY
				swbreak
				case '='
					if (tte!=TTE_KEY) {continue}
					if (len_token==0) {flg_broken=TRUE : break}	//�L�[�����󕶎���
					resetToken
					tte=TTE_VAL
				swbreak
				case '	'
					if ((tte==TTE_SECTNAME)||(tte==TTE_VAL)) {flg_broken=TRUE : break}
					offsetFromLineHead++ : cntTabFromLineHead++
				swbreak
				case 10
					if (peek(nini,count-2)==13) {	//���s
						offsetFromLineHead=0 : cntTabFromLineHead=0
						resetToken
						tte=TTE_KEY
					}
				swbreak
				default
					poke bufToken, len_token, byte : len_token++
					poke bufToken, len_token, 0
			swend
		loop
		errLine_=getCurLine()
		if (flg_broken) {return FALSE}
		if (cntSectStack!=0) {return FALSE}
		return TRUE
	#defcfunc local getCurLine //���݃J�E���^������s��Ԃ�
		tmp=strmid(nini,0,count) : strrep tmp, "\n","\n"
		return stat
	#deffunc local resetToken
		poke bufToken,0,0 : len_token=0
		return
#global

#module mod_nini
	#deffunc local init
		ninis=0 : idSel=0 : errLine=0
		return
	#deffunc nini_mount str nini_, int opt_noInspect	//nini�̃}�E���g
		/*
			[����]
				nini_mount nini, opt_noInspect
				nini : nini�e�L�X�g�f�[�^
				opt_noInspect : �����I�v�V�����B(FALSE,TRUE)=(�������s��,�s��Ȃ�)
			[stat]
				(-1,ID)=(�f�[�^�ُ�,ID)
		*/
		if (opt_noInspect==FALSE) {
			if (nini_isValidNini(nini_,errLine)==FALSE) {return -1}
		}
		newmod ninis, mv_nini, nini_
		return stat
	#deffunc nini_unmount int id_	//nini�̃A���}�E���g
		/*
			[����]
				nini_unmount id
				id : ID
			[stat]
				(0,1)=(����,ID�s��)
		*/
		if (existNini(id_)==FALSE) {return 1}
		delmod ninis(id_)
		return 0
	#defcfunc local existNini int id_	//nini�̑��݊m�F
		if (id_<0) {return FALSE} : if (varuse(ninis(id_))==0) {return FALSE}
		return TRUE
	#deffunc nini_create	//���nini���쐬
		/*
			[����]
				nini_create
			[stat]
				ID
		*/
		nini_mount "<body>\n</body>"
		return stat
	#deffunc nini_sel int id_	//�����nini�̐ݒ�
		/*
			[����]
				nini_sel id
				id : ID
			[stat]
				(0,1)=(����,ID�s��)
		*/
		if (existNini(id_)==FALSE) {return 1}
		idSel=id_
		return 0
	#defcfunc nini_getCurLine	//���݂̃J�E���^�̂���s���擾
		return getCurLine@mv_nini(ninis(idSel))
	#defcfunc nini_export	//nini�̃G�N�X�|�[�g
		/*
			[����]
				nini = nini_export()
				nini : �e�L�X�g�f�[�^�̊i�[��(�������s�v)
		*/
		return getText@mv_nini(ninis(idSel))
	#defcfunc nini_existSection str sectionName_	//�Z�N�V�����̑��ݒ���
		/*
			[����]
				val = nini_existSection(name)
				name : �Z�N�V������
			[�߂�l]
				(0,1)=(�Ȃ�,����)
		*/
		return existSection@mv_nini(ninis(idSel),sectionName_)
	#deffunc nini_enumSections array list_	//�I������Ă���Z�N�V�������̃Z�N�V�������
		/*
			[����]
				nini_enumSections list
				list : ���X�g���i�[���镶����^�z��(�������s�v)
			[stat]
				���������Z�N�V�����̐�
		*/
		enumSections@mv_nini ninis(idSel),list_
		return stat
	#deffunc nini_selSection str sectionName_	//�Z�N�V�����̑I��
		/*
			[����]
				nini_selSection name
				name : �Z�N�V������
			[stat]
				(0,1)=(����,�Y���Ȃ�)
		*/
		selSection@mv_nini ninis(idSel),sectionName_
		return stat
	#defcfunc nini_curDepth	//���݂̐[��
		return getCurDepth@mv_nini(ninis(idSel))
	#deffunc nini_goUp	//�K�w��1�オ��
		/*
			[����]
				nini_goUp
			[stat]
				(0,1)=(����,���ɍŐ�)
		*/
		goUp@mv_nini ninis(idSel)
		return stat
	#deffunc nini_newSection str sectionName_	//�V�����Z�N�V����
		/*
			[����]
				nini_newSection name
				name : �Z�N�V������
			[stat]
				(0,1)=(����,�������邢��"!"�Ŏn�܂�̂ŕs��)
		*/
		newSection@mv_nini ninis(idSel),sectionName_
		return stat
	#deffunc nini_delCurSection	//�I�𒆂̃Z�N�V�����̍폜
		/*
			[����]
				nini_delCurSection
			[stat]
				(0,1)=(����,body�Z�N�V�����Ȃ̂ŏ����Ȃ�)
		*/
		delCurSection@mv_nini ninis(idSel)
		return stat
	#defcfunc nini_existKey str keyName_	//�L�[�̑��ݒ���
		/*
			[����]
				val = nini_existKey(name)
				name : �L�[��
			[�߂�l]
				(0,1)=(�Ȃ�,����)
		*/
		return existKey@mv_nini(ninis(idSel),keyName_)
	#deffunc nini_enumKeys array list_	//�I������Ă���Z�N�V�������̃L�[�̗�
		/*
			[����]
				nini_enumKeys list
				list : ���X�g���i�[���镶����^�z��(�������s�v)
			[stat]
				���������L�[�̐�
		*/
		emumKeys@mv_nini ninis(idSel),list_
		return stat
	#deffunc nini_newKey str keyName_, str val_	//�V�����L�[
		/*
			[����]
				nini_newKey name,val
				name : �L�[��
				val : �l
			[stat]
				(0,1)=(����,�����Ȃ̂ŕs��)
		*/
		newKey@mv_nini ninis(idSel),keyName_,val_
		return stat
	#deffunc nini_delKey str keyName_	//�L�[�̍폜
		/*
			[����]
				nini_delKey name
				name : �L�[��
			[stat]
				(0,1)=(����,��������)
		*/
		delKey@mv_nini ninis(idSel),keyName_
		return stat
	#defcfunc nini_getVal str keyName_, str default_	//�l�̓ǂݏo��
		/*
			[����]
				val=nini_getVal(name,default)
				name : �L�[��
				defaule : �L�[�����݂��Ȃ������ꍇ�̖߂�l
		*/
		return getVal@mv_nini(ninis(idSel),keyName_,default_)
	#deffunc nini_setVal str keyName_, str val_	//�l�̏�������
		/*
			[����]
				nini_setVal name,val
				name : �L�[��
				val : �l(������)
			[stat]
				(0,1)=(����,�L�[����������)
		*/
		setVal@mv_nini ninis(idSel),keyName_,val_
		return stat
#global

init@mod_nini
#undef FALSE
#undef TRUE
#undef MAX_LEN_SECTION_NAME
#undef MAX_LEN_KEY_NAME