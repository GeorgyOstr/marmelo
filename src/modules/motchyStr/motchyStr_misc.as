#module mstr_misc_0
	/*
		serializeStrArray
	
		[�@�\]
			������^�z��̒���
	
		[����]
			serializeStrArray strArray, text
	
			strArray	: ���񉻂�����������^�z��
			text		: �ϊ����ʂ̊i�[��ϐ�
	
		[���s���stat�̒l]
			����I�� : 0
			�ُ�I�� : 1
	*/
	#deffunc serializeStrArray array strArray, var text
		if (vartype(strArray)!=vartype("str")) : return 1
		l=length(strArray),length2(strArray),length3(strArray),length4(strArray)	//l(i) : ��i�����̒���
		nd=0 : repeat 4 : if (l(cnt)!=0){nd++}else{break} : loop	//�Ӗ��̂��鎟���̐�
		if (nd==0) : return 1
		/*
			���񉻃f�[�^�̃t�H�[�}�b�g
	
			text = "nd,l1,l2,l3,l4,l[0,0,0,0],str[0,0,0,0],l[0,0,0,1],str[0,0,0,1], ... ,l[a-1,b-1,c-1,d-1],str[a-1,b-1,c-1,d-1]"
	
			l1,l2,l3,l4 : ��1,2,3,4��������
			l[x,y,z,w] : ��(x,y,z,w)�v�f�̕�����̃o�C�g��
			str[x,y,z,w] : ��(x,y,z,w)�v�f
	
			�@�A���A�Ⴆ�� nd=2 �̗l�Ƀt�������łȂ��ꍇ(���������ꍇ���w��)�͒���0�̎����Ɋւ���f�[�^�͏������܂Ȃ��B
			���̏ꍇ�Al3,l4 �͏������܂�Ȃ����Al[0,0,0,0]��str[0,0,0,0]���������܂�Ȃ��B
		*/
		sdim text,64
		text+=str(nd)+"," : repeat nd : text+=str(l(cnt))+"," : loop
		repeat l
			if (nd==1) {text+=str(strlen(strArray(cnt)))+","+strArray(cnt)+","} else {
				cnt0=cnt
				repeat l(1)
					if (nd==2) {text+=str(strlen(strArray(cnt0,cnt)))+","+strArray(cnt0,cnt)+","} else {
						cnt1=cnt
						repeat l(2)
							if (nd==3) {text+=str(strlen(strArray(cnt0,cnt1,cnt)))+","+strArray(cnt0,cnt1,cnt)+","} else {
								cnt2=cnt : repeat l(3) : text+=str(strlen(strArray(cnt0,cnt1,cnt2,cnt)))+","+strArray(cnt0,cnt1,cnt2,cnt)+"," : loop
							}
						loop
					}
				loop
			}
		loop
		poke text, strlen(text)-1, 0 //�����̗]�v��","������
		return 0
	
	/*
		deserializeStrArray
	
		[�@�\]
			���񉻃f�[�^���當����^�z��𕜌�
	
		[����]
			deserializeStrArray strArray, text
	
			strArray	: �����敶����^�z��
			text		: ���񉻃f�[�^
	
		[���s���stat�̒l]
			����I�� : 0
			�ُ�I�� : 1
	*/
	#deffunc deserializeStrArray array strArray, var text
		sdim buf,64
		getstr buf,text,0,',' : rc=strsize : nd=int(buf)	//rc : readCounter
		if (nd==0) : return 1
		flg_error=0
		repeat nd
			getstr buf,text,rc,',' : rc+=strsize : l(cnt)=int(buf)
			if (l(cnt)==0) : flg_error=1 : break
		loop
		if (flg_error) : return 1
		sdim strArray, 64, l,l(1),l(2),l(3)
		
		repeat l
			if (nd==1) {gosub *getElement : strArray(cnt)=buf} else {
				cnt0=cnt
				repeat l(1)
					if (nd==2) {gosub *getElement : strArray(cnt0,cnt)=buf} else {
						cnt1=cnt
						repeat l(2)
							if (nd==3) {gosub *getElement : strArray(cnt0,cnt1,cnt)=buf} else {
								cnt2=cnt : repeat l(3) : gosub *getElement : strArray(cnt0,cnt1,cnt2,cnt)=buf : loop
							}
						loop
					}
				loop
			}
		loop
		return 0
		*getElement	//1�v�f�ǂݏo����buf�Ɋi�[
			getstr buf,text,rc,',' : rc+=strsize : ls=int(buf)	//������
			buf = strmid(text,rc,ls) : rc+=ls+1	//getstr�͎g��Ȃ�
			return
#global

#module mstr_misc_1
	#defcfunc hex2int str txt_	//16�i�����񂩂�int�֕ϊ�
		//txt_ : �ϊ���������B�v���t�B�b�N�X(0x)�͂����Ă��Ȃ��Ă��悢�B�����񂪈ُ�ȏꍇ��0��Ԃ��B
		txt=txt_
		lenTxt=strlen(txt) : if (lenTxt==0) {return 0}
		if (lenTxt>=2) {if (strmid(txt,0,2)=="0x") {memcpy txt,txt, lenTxt-2, 0,2 : lenTxt-=2}}	//�v���t�B�b�N�X������Ύ�菜��
		x=0	//�ϊ����ʂ̑����
		repeat lenTxt
			digit=peek(txt,lenTxt-1-cnt)	//1���ǂ�
			if ((digit>=48)&&(digit<=57)) {x+=(digit-48)<<(4*cnt) : continue}	//0�`9
			if ((digit>=65)&&(digit<=70)) {x+=(digit-55)<<(4*cnt) : continue}	//A�`F
			if ((digit>=97)&&(digit<=102)) {x+=(digit-87)<<(4*cnt) : continue}	//a�`f
			x=0 : break	//�ُ�
		loop
		return x
#global