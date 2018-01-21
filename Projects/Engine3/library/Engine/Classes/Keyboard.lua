local Class = class.NewClass("Keyboard")
Class.capture = false

function Class:Open()
    love.keyboard.setTextInput(true)
end

function Class:Close()
    love.keyboard.setTextInput(false)
end

function Class:CaptureKeyboardEvent()
    Class.capture = true
end