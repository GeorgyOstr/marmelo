/*
	�`�惉�C�u���� "motchyDraw"
	
	��� : motchy
	MIT���C�Z���X
*/

#ifndef NULL
	#define global NULL	0
#endif
#ifndef DONTCARE_INT
	#define global DONTCARE_INT	0
#endif

/* 2D */
	#module mdraw2D_0
		#uselib "gdi32.dll"
			#func PlgBlt "PlgBlt" int, var, int, int,int, int,int, int, int,int
		
		vramSrc=0 : vramDst=0	//���������ϐ��x�����
		
		#deffunc boldLine_2D int Ax,int Ay,int Bx,int By, int b
			/*
				����b�̑���AB; A=(Ax,Ay),B=(Bx,By) ��`���B
				�F�̓J�����g�J���[�Bgmode�̔������ݒ肪�K�p�����B
		
				[����]
						boldLine_2D Ax,Ay,Bx,By, b
						
				[���l]
						b�͊�𐄏��B
			*/
			dx = double(Bx-Ax) : dy = double(By-Ay)
			if ((dx==0)&&(dy==0)) : return
			�� = double(b-1)*0.5/sqrt(dx*dx+dy*dy)
			xrect = Ax-dy*��, Ax+dy*��, xrect(1)+dx, xrect+dx
			yrect = Ay+dx*��, Ay-dx*��, yrect(1)+dy, yrect+dy
			gsquare -1, xrect,yrect
			return
		
		#deffunc arrowLine_2D int Ax,int Ay, int Bx,int By, double a, double ��
			/*
				����1�̖��AB; A=(Ax,Ay),B=(Bx,By) ��`���B
				�F�̓J�����g�J���[�B
		
				[����]
						arrowLine_2D Ax,Ay,Bx,By, a,��
		
						a : ���̒���
						�� : �w�b�h�̊J���p�x�̔���[rad]
			*/
			dx = double(Bx-Ax) : dy = double(By-Ay)
			�� = a/sqrt(dx*dx+dy*dy)
			cos�� = cos(��) : sin�� = sin(��)
			line Bx,By,Ax,Ay
			line Bx-(cos��*dx-sin��*dy)*��, By-(sin��*dx+cos��*dy)*��
			line Bx-(cos��*dx+sin��*dy)*��, By+(sin��*dx-cos��*dy)*��, Bx,By
			return
		
		#deffunc rotBmp90DegStep int widSrc_, int xSrc_,int ySrc_, int sx_,int sy_, int deg_
			/*
				�r�b�g�}�b�v��+90�x�̐����{��]���ăR�s�[����B
				�R�s�[��͌��ݑI������Ă���E�B���h�E�B�\��t���捶����W�̓J�����g�|�W�V�����B
	
				widSrc_ : �R�s�[���E�B���h�EID
				xSrc_,ySrc_	: �R�s�[��������W
				sx_sy_ : �R�s�[����c���T�C�Y
				deg_	: ��]�p�x�B90,180,270 �̂����ꂩ�B
	
				[���l]
					�R�s�[���ƃR�s�[�悪�d�Ȃ�ꍇ�̓���͖���B
					�R�s�[��,�R�s�[��ŃE�B���h�E�̏������T�C�Y����͂ݏo�镔���̓X�L�b�v����B
					�R�s�[���redraw�͍s��Ȃ��B
			*/
			assert ((sx_>0)&&(sy_>0))
			/* �R�s�[���� */
				xDst=ginfo_cx : yDst=ginfo_cy	//�\��t���捶����W
				sxWndDst=ginfo_sx : syWndDst=ginfo_sy	//�o�b�t�@xy�T�C�Y
				mref vramDst,66 : if (sxWndDst\4==0) {srVramDst=3*sxWndDst} else {srVramDst=(3*sxWndDst)/4*4+4}	//VRAM�o�b�t�@�s�������T�C�Y
			/* �R�s�[����� */
				wid_sel=ginfo_sel : gsel widSrc_
				sxWndSrc=ginfo_sx : syWndSrc=ginfo_sy
				mref vramSrc,66 : if (sxWndSrc\4==0) {srVramSrc=3*sxWndSrc} else {srVramSrc=(3*sxWndSrc)/4*4+4}
				gsel wid_sel
			switch deg_	//�������̂��߂Ɋp�x�ʂɏ�������
				case 90
					memo_x2=xDst+sy_-1+ySrc_ : memo_y2=yDst-xSrc_
					repeat sx_*sy_
						x1=xSrc_+cnt\sx_ : y1=ySrc_+cnt/sx_
						if ((x1<0)||(x1>=sxWndSrc)||(y1<0)||(y1>=syWndSrc)) {continue}	//�R�s�[������͂ݏo��
						x2=memo_x2-y1 : y2=memo_y2+x1
						if ((x2<0)||(x2>=sxWndDst)||(y2<0)||(y2>=syWndDst)) {continue}	//�R�s�[�悩��͂ݏo��
						adrVramSrc=(syWndSrc-y1-1)*srVramSrc+3*x1	//�R�s�[���̒��ړ_��B�l�̃A�h���X
						adrVramDst=(syWndDst-y2-1)*srVramDst+3*x2	//�R�s�[��́V
						wpoke vramDst, adrVramDst, wpeek(vramSrc,adrVramSrc) : poke vramDst,adrVramDst+2,peek(vramSrc,adrVramSrc+2)	//1�h�b�g�R�s�[
					loop
				swbreak
				case 180
					memo_x2=xDst+sx_-1+xSrc_ : memo_y2=yDst+sy_-1+ySrc_
					repeat sx_*sy_
						x1=xSrc_+cnt\sx_ : y1=ySrc_+cnt/sx_ : if ((x1<0)||(x1>=sxWndSrc)||(y1<0)||(y1>=syWndSrc)) {continue}
						x2=memo_x2-x1 : y2=memo_y2-y1 : if ((x2<0)||(x2>=sxWndDst)||(y2<0)||(y2>=syWndDst)) {continue}
						adrVramSrc=(syWndSrc-y1-1)*srVramSrc+3*x1 : adrVramDst=(syWndDst-y2-1)*srVramDst+3*x2
						wpoke vramDst, adrVramDst, wpeek(vramSrc,adrVramSrc) : poke vramDst,adrVramDst+2,peek(vramSrc,adrVramSrc+2)
					loop
				swbreak
				case 270
					memo_x2=xDst-ySrc_ : memo_y2=yDst+sx_-1+xSrc_
					repeat sx_*sy_
						x1=xSrc_+cnt\sx_ : y1=ySrc_+cnt/sx_ : if ((x1<0)||(x1>=sxWndSrc)||(y1<0)||(y1>=syWndSrc)) {continue}
						x2=memo_x2+y1 : y2=memo_y2-x1 : if ((x2<0)||(x2>=sxWndDst)||(y2<0)||(y2>=syWndDst)) {continue}
						adrVramSrc=(syWndSrc-y1-1)*srVramSrc+3*x1 : adrVramDst=(syWndDst-y2-1)*srVramDst+3*x2
						wpoke vramDst, adrVramDst, wpeek(vramSrc,adrVramSrc) : poke vramDst,adrVramDst+2,peek(vramSrc,adrVramSrc+2)
					loop
				swbreak
			swend
			return
	
		#deffunc rotBmp90DegStep_PlgBlt int widSrc_, int xSrc_,int ySrc_, int sx_,int sy_, int deg_
			/*
				PlgBlt�𗘗p���ăr�b�g�}�b�v��+90�x�̐����{��]���ăR�s�[����B
				�R�s�[��͌��ݑI������Ă���E�B���h�E�B�\��t���捶����W�̓J�����g�|�W�V�����B
	
				widSrc_ : �R�s�[���E�B���h�EID
				xSrc_,ySrc_	: �R�s�[��������W
				sx_sy_ : �R�s�[����c���T�C�Y
				deg_	: ��]�p�x�B90,180,270 �̂����ꂩ�B
	
				[���l]
					�R�s�[���ƃR�s�[�悪�d�Ȃ�ꍇ�̓���͖���B
					�R�s�[���redraw�͍s��Ȃ��B
			*/
			assert ((sx_>0)&&(sy_>0))
			hdcDst=hdc : wid_sel=ginfo_sel : gsel widSrc_ : hdcSrc=hdc : gsel wid_sel
			switch deg_
				//�ʎq���덷��⏞���邽�߂ɍ��W�w�肪crazy
				case 90 : point=ginfo_cx+sy_,ginfo_cy, ginfo_cx+sy_,ginfo_cy+sx_, ginfo_cx,ginfo_cy : swbreak
				case 180 : point=ginfo_cx+sx_-1,ginfo_cy+sy_-1, ginfo_cx-1,ginfo_cy+sy_-1, ginfo_cx+sx_-1,ginfo_cy-1 : swbreak
				case 270 : point=ginfo_cx,ginfo_cy+sx_, ginfo_cx,ginfo_cy, ginfo_cx+sy_,ginfo_cy+sx_ : swbreak
			swend
			PlgBlt hdcDst, point, hdcSrc, xSrc_,ySrc_, sx_,sy_, NULL, DONTCARE_INT, DONTCARE_INT
			return
	#global
	
	#module mdraw2D_1
		#deffunc boldArrowLine_2D int Ax,int Ay, int Bx,int By, int b, double a, double ��
			/*
				����b�̖��AB; A=(Ax,Ay),B=(Bx,By) ��`���B
				�F�̓J�����g�J���[�Bgmode�̔������ݒ肪�K�p�����B
		
				[����]
						boldArrowLine_2D Ax,Ay,Bx,By, b,a,��
		
						a : ���̒���
						�� : �w�b�h�̊J���p�x�̔���[rad]
		
				[���l]
						b�͊�𐄏��B
			*/
			cos�� = cos(��) : sin�� = sin(��)
			dx = double(Bx-Ax) : dy = double(By-Ay)
			len = sqrt(dx*dx+dy*dy)
			�� = a/len
			h = a*cos��	//�w�b�h�̍���
			if len > h : boldLine_2D Ax,Ay, Ax+dx*(1.0-(h-1.0)/len), Ay+dy*(1.0-(h-1.0)/len), b	//AB���\��������΃V���t�g��`���Bgsquare��1px�قǌ�����̂�h��h-1�Ƃ��ĕ␳����B
			xrect = Bx, Bx, Bx-(cos��*dx+sin��*dy)*��, Bx-(cos��*dx-sin��*dy)*��
			yrect = By, By, By+(sin��*dx-cos��*dy)*��, By-(sin��*dx+cos��*dy)*��
			gsquare -1, xrect,yrect
			return
	#global

#undef NULL
#undef DONTCARE_INT