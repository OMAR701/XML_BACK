from flask import Flask
from flask_restful import Resource, Api, request
from lxml import etree as ET
import xmlschema as XS
app = Flask(__name__)
api = Api(app)

@app.route('/XML_DTD', methods=['POST','GET'])
def get_data():
    global dtd_valid, xml_valid
    if request.method == 'POST':
        if request.form.get("XML_TEXT"):
            with open('C:/Users/dell/Desktop/FlaskApi/static/file.xml', 'w') as f:
                f.write(request.form.get("XML_TEXT"))
        if request.form.get("DTD_TEXT"):
            with open('C:/Users/dell/Desktop/FlaskApi/static/file.dtd', 'w') as f:
                f.write(request.form.get("DTD_TEXT"))
        if request.files['XML_FILE']:
            f = open('C:/Users/dell/Desktop/FlaskApi/static/file.xml', 'wb')
            f.write(request.files['XML_FILE'].read())
            f.close()
        if request.files['DTD_FILE']:
            f = open('C:/Users/dell/Desktop/FlaskApi/static/file.dtd', 'wb')
            f.write(request.files['DTD_FILE'].read())
            f.close()
        dtd_valid = ET.DTD("C:/Users/dell/Desktop/FlaskApi/static/file.dtd")
        xml_valid = ET.parse("C:/Users/dell/Desktop/FlaskApi/static/file.xml")

    if request.method == 'POST' and dtd_valid and xml_valid:
        if dtd_valid.validate(xml_valid):
            return "your file is valid"
        else:
            return "your file is not valid"


@app.route('/XML_XSD', methods=['POST','GET'])
def get_results():
    global xsd_valid , xml_valid
    if request.method == 'POST':
        if request.form.get("XML_TEXT"):
            with open('C:/Users/dell/Desktop/FlaskApi/static/file.xml', 'w') as f:
                f.write(request.form.get("XML_TEXT"))
        if request.form.get("XSD_TEXT"):
            with open('C:/Users/dell/Desktop/FlaskApi/static/file.xsd', 'w') as f:
                f.write(request.form.get("XSD_TEXT"))
        if request.files['XML_FILE']:
            print("Omar")
            f = open('C:/Users/dell/Desktop/FlaskApi/static/file.xml', 'wb')
            f.write(request.files['XML_FILE'].read())
            f.close()
        if request.files['XSD_FILE']:
            print("kader")
            f = open('C:/Users/dell/Desktop/FlaskApi/static/file.xsd', 'wb')
            f.write(request.files['XSD_FILE'].read())
            f.close()
        xsd_valid = XS.XMLSchema("C:/Users/dell/Desktop/FlaskApi/static/file.xsd")
        xml_valid = ET.parse("C:/Users/dell/Desktop/FlaskApi/static/file.xml")

    if request.method == 'POST' and xsd_valid and xml_valid:
        if xsd_valid.is_valid(xml_valid):
            return "your file is valid"
        else:
            return "your file is not valid"

if __name__ == '__main__':
    app.run(debug=True)