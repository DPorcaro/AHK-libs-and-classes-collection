#Include <CMenuItem>

class CMenuBar
{
	; Instance properties
	; Menu name
	name := ""
  
  ; text for dropdown menus
  text := ""
  
	; Menu items
	items := []
  itemsByNames := {}
  ; submenus
;   submenus := []
	; A parent item object for a submenu
	parent := ""
	; A flag that is used to insert or remove all standard (non-custom) menu items from the tray menu (if they are present).
	standard := false
	; A variable that is used to set the Tray menu's default item or to change the menu back to having its standard default menu item, which is OPEN for non-compiled scripts and none for compiled scripts (except when the MainWindow option is in effect). If the OPEN menu item does not exist due to a previous use of the NoStandard command below, there will be no default and thus double-clicking the tray icon will have no effect. For menus other than TRAY: Any existing default item is returned to a non-bold font. 
	default := ""
	; A gui
	gui := {}
	
;
; Function: __New
; Description:
;		Creates an instance of MenuBase (not the menu itself).
; Syntax: __New(gui [, name, parent, standard, default])
; Parameters:
;		gui - Gui this menu belongs to.
; 		name - Menu name (as used in Menu, [b]name[/b], add, ...)
;		 parent - (Optional) (CMenuItem) A menu item containing this menu. Tray menu will always have parent = "" even if set.
;		 standard - (Optional) Inserts (if true) or removes (if false) standard menu items into this menu.
;		 default - (Optional) (MenuItemBase) Changes the menu's default item to be the specified item.
; Return Value:
;		Returns an instance of MenuBase.
; Remarks:
;		Use without parameters to create an empty tray menu with no default items.
; Example:
; 		mTray := new MenuBase()
;		mi := new MenuItemBase("MyMenuItem1", mTray)
;
	__New(name = "tray", parent = "", gui="", standard = false, default = "")
	{
		this.name := name
		if(this.name = "tray" or this.name = "Tray")
		{
      this.name := "tray"
			this.parent := ""
      this.gui := ""
			this.default := default
		}
		else
		{
			this.parent := parent
			this.default := ""
      this.gui := gui
      this.parent.AddLastSubmenu(this)
		}
		this.standard := standard
;     OutputDebug % "MenuBar.__New result : name = " this.name
	}

;
; Function: Create
; Description:
;                Creates the menu and all its items (if any).
; Syntax: Object.Create()
; Remarks:
;                The menu is not created if it nas ho items.
;
	Create()
	{
;     OutputDebug % "In MenuBar.Create(" this.name ")"
    
		if(IsEmpty(this.items) && IsEmpty(this.submenus))
			return
      
    if(this.name = "tray")
    {
      if(!this.standard)
      {
        menu, tray, NoStandard
      }
      if(this.default = "")
      {
        menu, tray, NoDefault
      }
    }
    
    for i, item in this.items
		{
			; We do not check here if an item is created because this check is performed in item.Create()
			item.Create()
		}
		
;     for i, item in this.submenus
; 		{
; 			; We do not check here if an item is created because this check is performed in item.Create()
; 			item.Create()
; 		}
    
    if(this.parent)
    {
;       OutputDebug % "Adding to the parent: Menu, " this.parent.name ", add, :" _t(this.name)
      Menu, % this.parent.name, add, % _t(this.name), % ":" this.name
      this.text := _t(this.name)
    }
		; Set the flag
		this.created := true
;     OutputDebug % "Leaving MenuBar.Create(" this.name ")" 
	}
	
	AddLastItem(name = "", label = "")
	{
; 		OutputDebug, Adding menu item %name% > %label%
		mi := new CMenuItem(this, name, label)
		this.items.insert(mi)
    if(name)
    {
      this.itemsByNames[name] := mi
    }
;     mi.position := this.items.maxindex()
		return mi
	}
  
  AddLastSubmenu(submenu)
	{
; 		OutputDebug, % "Adding submenu " submenu.name
		this.items.insert(submenu)
    if(submenu.name)
    {
      this.itemsByNames[submenu.name] := submenu
    }
	}
  
  AddFirstItem(name = "", label = "")
	{
; 		OutputDebug, Adding menu item %name% > %label%
		mi := new CMenuItem(this, name, label)
		this.items.insert(1, mi)
    if(name)
    {
      this.itemsByNames[name] := mi
    }
		return mi
	}
  
  RemoveLastItem()
  {
    if(this.items)
    {
      if(this.created)
        Menu, % this.name, delete, % this.items[Count(this.items)].name
      this.items.Remove()
    }
  }
  
  RemoveItems()
  {
    if(this.created)
    {
      Menu, % this.name, deleteAll
    }
    this.items := []
    this.itemsByNames := {}
  }
  
  Localize()
  {
    for i, item in this.items
    {
      item.Localize()
    }
    
    if(this.parent)
    {
;       OutputDebug % "Adding to the parent: Menu, " this.parent.name ", add, :" _t(this.name)
      Menu, % this.parent.name, Rename, % this.text, % _t(this.name)
      this.text := _t(this.name)
    }
  }
}