(import bpy)

(setv bl-info {
  :name "Cursor Array"
  :blender (, 2 81 0)
  :category "Object"
})


(defclass ObjectCursorArray [(. bpy types Operator)]
  "Object Cursor Array"
  (setv bl-idname "object.cursor_array")
  (setv bl-label "Cursor Array")
  (setv bl-options #{"REGISTER" "UNDO"})

  (^((. bpy props IntProperty) :name "Steps" :default 2 :min 1 :max 100) total)

  (defn execute [self context]
    (setv scene (. context scene))
    (setv cursor (. scene cursor location))
    (setv obj (. context active-object))

    (for [i (range (. self total))]
      (setv obj-new ((. obj copy)))
      ((. scene collection objects link) obj-new)

      (setv factor (/ i (. self total)))
      (setv (. obj-new location) (+ (* (. obj location) factor) (* cursor (- 1.0 factor)))))

    #{"FINISHED"}))


(defn menu_func [self context]
  ((. self layout operator) (. ObjectCursorArray bl-idname)))

; store keymaps here to access after registration
(setv addon-keymaps [])


(defn register []
  ((. bpy utils register-class) ObjectCursorArray)
  ((. bpy types VIEW3D-MT-object append) menu-func)

  ;; handle the keymap
  (setv wm (. bpy context window-manager))
  ;; Note that in background mode (no GUI available), keyconfigs are not available either,
  ;; so we have to check this to avoid nasty errors in background case.
  (setv kc (. wm keyconfigs addon))
  (when kc
    (setv km ((. wm keyconfigs addon keymaps new) :name "Object Mode" :space-type "EMPTY"))
    (setv kmi ((. km keymap-items new) (. ObjectCursorArray bl-idname) "T" "PRESS" :ctrl True :shift True))
    (setv (. kmi properties total) 4)
    ((. addon-keymaps append) (, km kmi))))

(defn unregister []
  ;; Note: when unregistering, it's usually good practice to do it in reverse order you registered.
  ;; Can avoid strange issues like keymap still referring to operators already unregistered...
  ;; handle the keymap
  (for [(, km kmi) addon-keymaps]
    ((. km keymap-items remove) kmi))
  ((. addon-keymaps clear))

  ((. bpy utils unregister-class) ObjectCursorArray)
  ((. bpy types VIEW3D-MT-object remove) menu-func))


(when (= --name-- "__main__")
    (register))