#module MM_sort_0
	/*
		�N�C�b�N�\�[�g
	
		[����]
	
			quickSort a,s,e,o
	
			a	: �Ώ۔z��(int,double)
			s,e	: �Ώۋ�ԊJ�n,�I���ʒu(int)
			o	: (����,�~��)=(0,1)
			
	*/
	#deffunc quickSort array a, int s, int e, int o, local l, local r
		if (s<e) {
			if (o) {	//�~��
				/* �����i�K */
					p = a(e)	//�s�{�b�g
					l = s : r = e-1
					repeat
						repeat
							if (a(l)>p) : l++ : else : break
						loop
						repeat
							if (l>r) : break	//�����l�𕡐����f�[�^��ɑ΂��Ă�r�����ɂȂ邱�Ƃ�����̂ŒP�ƂŃ`�F�b�N���Ȃ��ƃI�[�o�[�t���[����
							if (a(r)<=p) : r-- : else : break
						loop
						if (l<r) {x=a(l) : a(l)=a(r) : a(r)=x} else : break
					loop
					x=a(l) : a(l)=a(e) : a(e)=x
				/* �ċA�Ăяo�� */
						if (l-1-s < e-l-1) {	//�Z����Ԃ�D��I�ɏ�������sublev��ߖ�
							quickSort a,s,l-1, 1 : quickSort a,l+1,e, 1
						} else {
							quickSort a,l+1,e, 1 : quickSort a,s,l-1, 1
						}
			} else {	//����
					/* �����i�K */
						p = a(e)
						l = s : r = e-1
						repeat
							repeat
								if (a(l)<p) : l++ : else : break
							loop
							repeat
								if (l>r) : break
								if (a(r)>=p) : r-- : else : break
							loop
							if (l<r) {x=a(l) : a(l)=a(r) : a(r)=x} else : break
						loop
						x=a(l) : a(l)=a(e) : a(e)=x
					/* �ċA�Ăяo�� */
						if (l-1-s < e-l-1) {
							quickSort a,s,l-1, 0 : quickSort a,l+1,e, 0
						} else {
							quickSort a,l+1,e, 0 : quickSort a,s,l-1, 0
						}
			}
		}
		return
	
	/*
		�����N�C�b�N�\�[�g
	
		[����]
	
			quickSortSync a,b,s,e,o
	
			a	: �}�X�^�[�z��(int,double)
			b	: �X���[�u�z��
			s,e	: �Ώۋ�ԊJ�n,�I���ʒu(int)
			o	: (����,�~��)=(0,1)
	*/
	#deffunc quickSortSync array a, array b, int s, int e, int o, local l, local r
		if (s<e) {
			if (o) {	//�~��
				/* �����i�K */
					p = a(e)	//�s�{�b�g
					l = s : r = e-1
					repeat
						repeat
							if (a(l)>p) : l++ : else : break
						loop
						repeat
							if (l>r) : break	//�����l�𕡐����f�[�^��ɑ΂��Ă�r�����ɂȂ邱�Ƃ�����̂ŒP�ƂŃ`�F�b�N���Ȃ��ƃI�[�o�[�t���[����
							if (a(r)<=p) : r-- : else : break
						loop
						if (l<r) {
							x=a(l) : a(l)=a(r) : a(r)=x
							y=b(l) : b(l)=b(r) : b(r)=y	//���ϐ��̌^�ϊ��ɂ��x��������邽�߂ɕϐ���x,y�Ŏg��������
						} else : break
					loop
					x=a(l) : a(l)=a(e) : a(e)=x
					y=b(l) : b(l)=b(e) : b(e)=y
				/* �ċA�Ăяo�� */
					if (l-1-s < e-l-1) {	//�Z����Ԃ�D��I�ɏ�������sublev��ߖ�
						quickSortSync a,b,s,l-1, 1 : quickSortSync a,b,l+1,e, 1
					} else {
						quickSortSync a,b,l+1,e, 1 : quickSortSync a,b,s,l-1, 1
					}
			} else {	//����
				/* �����i�K */
					p = a(e)	//�s�{�b�g
					l = s : r = e-1
					repeat
						repeat
							if (a(l)<p) : l++ : else : break
						loop
						repeat
							if (l>r) : break
							if (a(r)>=p) : r-- : else : break
						loop
						if (l<r) {
							x=a(l) : a(l)=a(r) : a(r)=x
							y=b(l) : b(l)=b(r) : b(r)=y
						} else : break
					loop
					x=a(l) : a(l)=a(e) : a(e)=x
					y=b(l) : b(l)=b(e) : b(e)=y
				/* �ċA�Ăяo�� */
					if (l-1-s < e-l-1) {
						quickSortSync a,b,s,l-1, 0 : quickSortSync a,b,l+1,e, 0
					} else {
						quickSortSync a,b,l+1,e, 0 : quickSortSync a,b,s,l-1, 0
					}
			}
		}
		return
#global

#module MM_sort_1
	/*
		�N�C�b�N�\�[�g(��ċA������)
	
		[����]
	
			quickSort_nr a,s,e,o
	
			a	: �Ώ۔z��(int,double)
			s,e	: �Ώۋ�ԊJ�n,�I���ʒu(int)
			o	: (����,�~��)=(0,1)
	*/
	#deffunc quickSort_nr array a, int _s,int _e, int o
		if (_e<=_s) : return
		stack=_s,_e	//�X�^�b�N�B[2*i],[2*i+1] = i�ڂ̗̈�̍��[,�E�[�C���f�b�N�X
		sc=1	//�X�^�b�N�J�E���^
		if (o) {	//�~��
			repeat
				if (sc==0) : break
				s=stack(2*sc-2) : e=stack(2*sc-1) : sc--	//pop
				p = a(e)	//�s�{�b�g
				l=s : r=e-1
				repeat
					repeat
						if (a(l)>p) : l++ : else : break
					loop
					repeat
						if (l>r) : break
						if (a(r)<=p) : r-- : else : break
					loop
					if (l<r) {x=a(l) : a(l)=a(r) : a(r)=x} else : break
				loop
				x=a(l) : a(l)=a(e) : a(e)=x
				/* push */
				if (s<l-1) : stack(2*sc)=s,l-1 : sc++
				if (l+1<e) : stack(2*sc)=l+1,e : sc++
			loop
		} else {	//����
			repeat
				if (sc==0) : break
				s=stack(2*sc-2) : e=stack(2*sc-1) : sc--	//pop
				p = a(e)	//�s�{�b�g
				l=s : r=e-1
				repeat
					repeat
						if (a(l)<p) : l++ : else : break
					loop
					repeat
						if (l>r) : break
						if (a(r)>=p) : r-- : else : break
					loop
					if (l<r) {x=a(l) : a(l)=a(r) : a(r)=x} else : break
				loop
				x=a(l) : a(l)=a(e) : a(e)=x
				/* push */
				if (s<l-1) : stack(2*sc)=s,l-1 : sc++
				if (l+1<e) : stack(2*sc)=l+1,e : sc++
			loop
		}
		return
	
	/*
		�����N�C�b�N�\�[�g(��ċA������)
	
		[����]
	
			quickSortSync_nr a,b,s,e,o
	
			a	: �}�X�^�[�z��(int,double)
			b	: �X���[�u�z��
			s,e	: �Ώۋ�ԊJ�n,�I���ʒu(int)
			o	: (����,�~��)=(0,1)
	*/
	#deffunc quickSortSync_nr array a,array b, int _s,int _e, int o
		if (_e<=_s) : return
		stack=_s,_e	//�X�^�b�N�B[2*i],[2*i+1] = i�ڂ̗̈�̍��[,�E�[�C���f�b�N�X
		sc=1	//�X�^�b�N�J�E���^
		if (o) {	//�~��
			repeat
				if (sc==0) : break
				s=stack(2*sc-2) : e=stack(2*sc-1) : sc--	//pop
				p = a(e)	//�s�{�b�g
				l=s : r=e-1
				repeat
					repeat
						if (a(l)>p) : l++ : else : break
					loop
					repeat
						if (l>r) : break
						if (a(r)<=p) : r-- : else : break
					loop
					if (l<r) {
						x=a(l) : a(l)=a(r) : a(r)=x
						y=b(l) : b(l)=b(r) : b(r)=y
					} else : break
				loop
				x=a(l) : a(l)=a(e) : a(e)=x
				y=b(l) : b(l)=b(e) : b(e)=y
				/* push */
				if (s<l-1) : stack(2*sc)=s,l-1 : sc++
				if (l+1<e) : stack(2*sc)=l+1,e : sc++
			loop
		} else {	//����
			repeat
				if (sc==0) : break
				s=stack(2*sc-2) : e=stack(2*sc-1) : sc--	//pop
				p = a(e)	//�s�{�b�g
				l=s : r=e-1
				repeat
					repeat
						if (a(l)<p) : l++ : else : break
					loop
					repeat
						if (l>r) : break
						if (a(r)>=p) : r-- : else : break
					loop
					if (l<r) {
						x=a(l) : a(l)=a(r) : a(r)=x
						y=b(l) : b(l)=b(r) : b(r)=y
					} else : break
				loop
				x=a(l) : a(l)=a(e) : a(e)=x
				y=b(l) : b(l)=b(e) : b(e)=y
				/* push */
				if (s<l-1) : stack(2*sc)=s,l-1 : sc++
				if (l+1<e) : stack(2*sc)=l+1,e : sc++
			loop
		}
		return
#global