/*
	�G������
*/
#module mgui_misc
	#defcfunc mgui_getEditText int hwnd_edit_	//�G�f�B�b�g�R���g���[���̃e�L�X�g���擾
		//hwnd_edit_ : �G�f�B�b�g�R���g���[���̃E�B���h�E�n���h��
		sendmsg hwnd_edit_, WM_GETTEXTLENGTH, 0,0
		sdim buf, stat+1 : sendmsg hwnd_edit_, WM_GETTEXT, stat+1,varptr(buf)
		return buf
#global