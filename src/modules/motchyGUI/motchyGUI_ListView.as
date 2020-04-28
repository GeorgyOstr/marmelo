#module mgui_ListView
	#defcfunc mgui_createListView int sx_,int sy_
		/*
			�J�����g�|�W�V�����Ƀ��X�g�{�b�N�X��ݒu����
			
			sx_,sy_ : ���X�g�{�b�N�X��x,y�T�C�Y
	
			[�߂�l]
				�쐬���ꂽ���X�g�r���[�̃n���h��
		*/
		winobj "SysListView32", "ListView", 0, WS_VISIBLE|WS_CHILD|LVS_REPORT, sx_,sy_
		return objinfo(stat,2)
	
	#deffunc mgui_addLVCol int hwndLV_, int id_, int fmt_, int cx_, str szText_
		/*
			���X�g�{�b�N�X�ɃJ������ǉ�����
	
			hwndLV_	: ���X�g�r���[�̃E�B���h�E�n���h��
			id_		: �J������ID(������0,1,2,�c)
			fmt_	: LVCOLUMN�\���̂�fmt�����o
			cx_		: �J�����̕�[px]
			szText_	: �J�����w�b�_�̃e�L�X�g
	
			[�߂�l]
				(-1,other)=(���s,�쐬���ꂽ�J������ID)
		*/
		szText=szText_ : lvcolumn = LVCF_FMT|LVCF_WIDTH|LVCF_TEXT, fmt_, cx_, varptr(szText)
		sendmsg hwndLV_, LVM_INSERTCOLUMN, id_, varptr(lvcolumn)
		return stat
	
	#deffunc mgui_addLVItem int hwndLV_, int id_, str szText_
		/*
			���X�g�{�b�N�X�ɃA�C�e����ǉ�����
	
			hwndLV_	: ���X�g�{�b�N�X�̃E�B���h�E�n���h��
			id_		: �A�C�e����ID(�ォ��0,1,2,�c)
			szText_	: �A�C�e���̕�����
	
			[�߂�l]
				(-1,other)=(���s,�ǉ����ꂽ�A�C�e���̃C���f�b�N�X)
		*/
		szText=szText_ : lvitem = LVIF_TEXT, id_, 0, DCINT,DCINT, varptr(szText)
		sendmsg hwndLV_, LVM_INSERTITEM, 0, varptr(lvitem)
		return stat
	
	#deffunc mgui_setLVSubItem int hwndLV_, int idItem_, int idSubItem_, str szText_
		/*
			���X�g�r���[�ɃT�u�A�C�e����ݒ肷��
	
			hwndLV_	: ���X�g�r���[�̃E�B���h�E�n���h��
			idItem_	: �A�C�e����ID
			idSubItem	: �T�u�A�C�e����ID
	
			[�߂�l]
				(TRUE,FALSE)=(����,���s)
		*/
		szText=szText_ : lvitem = LVIF_TEXT, idItem_, idSubItem_, DCINT,DCINT, varptr(szText)
		sendmsg hwndLV_, LVM_SETITEM, 0, varptr(lvitem)
		return stat
#global