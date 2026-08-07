
local ElementType = {}
ElementType.Eidt_Undefine = 0
ElementType.Edit_CCNode = 1
ElementType.Edit_Sprite = 2
ElementType.Edit_Particle = 3
ElementType.Edit_WydAnim = 4
ElementType.Edit_Scale9Sprite = 5


local AnimationType = {}
AnimationType.Animation_Undefine = 0
AnimationType.MoveTo 	= 1
AnimationType.ScaleTo 	= 2
AnimationType.ColorTo 	= 3
AnimationType.OpacityTo = 4
AnimationType.Animate 	= 5
AnimationType.TintTo 	= 6
AnimationType.RotateTo 	= 7
AnimationType.SetFreame = 8--lua 版不支持
AnimationType.Callback  = 9--关键帧回调

local PropertyType = {}
PropertyType.property_none				= 0
PropertyType.property_IgnoreAnchorpoint	= 1
PropertyType.property_anchorpoint		= 2
PropertyType.property_position			= 3
PropertyType.property_size				= 4
PropertyType.property_scale				= 5
PropertyType.property_rotation			= 6
PropertyType.property_color				= 7
PropertyType.property_texture			= 8
PropertyType.property_particle			= 9
PropertyType.property_blend				= 10
PropertyType.property_wydanim			= 11
PropertyType.property_skew				= 12
PropertyType.property_insetTop			= 13
PropertyType.property_insetBottom		= 14
PropertyType.property_insetLeft			= 15
PropertyType.property_insetRight		= 16
PropertyType.property_extFlag			= 17--关键帧回调


rawset(_G, "ElementType", ElementType)
rawset(_G, "AnimationType", AnimationType)
rawset(_G, "PropertyType", PropertyType)