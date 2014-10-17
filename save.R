save.workspace = function(filename="ws/workspace.RData") {
   message(sprintf("Saving workspace to '%s'...", filename))
   save.image(filename, safe=TRUE)
}

load.workspace = function(filename="ws/workspace.RData") {
   message(sprintf("Loading workspace '%s'...", filename))
   load(filename)
}

save.model = function(model, filename) {
   save("model", file=sprintf("models/%s.RMod", filename))
}