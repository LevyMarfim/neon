local tex = require("texlike")

-- Use TeX-like commands
tex.text("Hello, world!")
tex.font("Times-Roman", 14)
tex.text("This is typeset in Times Roman")
tex.font("Helvetica", 12)
tex.text("Back to Helvetica")
tex.paragraph()
tex.text("New paragraph starts here")

-- Generate PDF
tex.generate("output.pdf")
print("PDF generated as output.pdf")