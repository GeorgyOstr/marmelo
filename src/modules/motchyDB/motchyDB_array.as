#module motchyDB_array
	#defcfunc searchLinearIntArray int val_, array a_, int s_,int e_
		/*
			1����int�z�񂩂�l����������
	
			val_	: ��������l
			a_		: �z��
			s_,e_	: �����J�n,�I���C���f�b�N�X
	
			[�߂�l]
				(-1,other)=(��������,�ŏ��Ƀq�b�g�����C���f�b�N�X)
		*/
		if (e_<s_) {return -1}
		rc=-1 : repeat e_-s_+1,s_ : if (a_(cnt)==val_) {rc=cnt : break} : loop
		return rc
#global