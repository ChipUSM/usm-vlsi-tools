from pathlib import Path
import xml.etree.ElementTree as ET
from xml.etree.ElementTree import Element
import argparse
import re

## See this format document
## https://www.klayout.de/rdb_format.html


def get_child_element(root: Element, tag) -> Element | None:
    for child in root:
        if child.tag == tag:
            return child

    return None


def generate_text_element(tag, text):
    elem = Element(tag)
    elem.text = text
    return elem


def generate_symbol_element(name, expr):
    return generate_text_element("symbols", f"{name}='{expr}'")


def generate_connection_element(layer1, via, layer2):
    return generate_text_element("connection", f"{layer1},{via},{layer2}")


def connectivity_validation(connectivity: Element):
    # Holds all defined symbols. Some of them might be used on other symbol definition.
    symbols_defined = set()

    for elem in connectivity.iter("symbols"):
        symbols_defined.add(elem.text.split("=")[0])

    # Holds symbol names used on connections and while defining another symbol
    symbols_used = set()
    for elem in connectivity.iter("connection"):
        symbols_used.update(elem.text.split(","))

    split_pattern = "|".join(map(re.escape, ["+", "-"]))
    for elem in connectivity.iter("symbols"):
        symbol_definition = elem.text.split("=")[1].replace("'", "")
        symbols_on_definition = re.split(split_pattern, symbol_definition, 0)
        symbols_used.update([sym for sym in symbols_on_definition if "/" not in sym])

    # print(f"{symbols_used =    }")
    # print(f"{symbols_defined = }")

    if symbols_defined - symbols_used != set():
        raise RuntimeError(
            f"Some symbols are not used: {symbols_defined - symbols_used}"
        )

    if symbols_used - symbols_defined != set():
        raise RuntimeError(
            f"Connections use undefined symbols: {symbols_used - symbols_defined}"
        )


def get_sky130_connectivity():
    # https://skywater-pdk.readthedocs.io/en/main/rules/layers.html

    def metal_connectivity(layer):
        expr = f"{layer}/20"  # Drawing
        expr += f"+{layer}/5"  # Label
        expr += f"-{layer}/13"  # Res
        return expr

    connectivity = Element("connectivity")

    connectivity.append(generate_symbol_element("capm", "89/44"))
    connectivity.append(generate_symbol_element("cap2m", "97/44"))

    connectivity.append(generate_symbol_element("poly", metal_connectivity(66)))
    connectivity.append(generate_symbol_element("li", metal_connectivity(67)))
    connectivity.append(generate_symbol_element("met1", metal_connectivity(68)))
    connectivity.append(generate_symbol_element("met2", metal_connectivity(69)))
    connectivity.append(generate_symbol_element("met3", metal_connectivity(70)))
    connectivity.append(generate_symbol_element("met4", metal_connectivity(71)))
    connectivity.append(generate_symbol_element("met5", metal_connectivity(72)))

    connectivity.append(generate_symbol_element("licon", "66/44"))
    connectivity.append(generate_symbol_element("mcon", "67/44"))
    connectivity.append(generate_symbol_element("via1", "68/44"))
    connectivity.append(generate_symbol_element("via2", "69/44"))
    connectivity.append(generate_symbol_element("via3", "70/44-capm"))
    connectivity.append(generate_symbol_element("via4", "71/44-cap2m"))

    connectivity.append(generate_connection_element("poly", "licon", "li"))
    connectivity.append(generate_connection_element("li", "mcon", "met1"))
    connectivity.append(generate_connection_element("met1", "via1", "met2"))
    connectivity.append(generate_connection_element("met2", "via2", "met3"))
    connectivity.append(generate_connection_element("met3", "via3", "met4"))
    connectivity.append(generate_connection_element("met4", "via4", "met5"))

    return connectivity


def get_gf180mcu_connectivity():
    connectivity = Element("connectivity")

    def metal_connectivity(layer):
        expr = f"{layer}/0"  # Drawing
        expr += f"+{layer}/10"  # Label
        expr += f"-{layer}/3"  # Slot
        return expr

    # connectivity.append(generate_symbol_element("comp", '22/0+22/10'))

    connectivity.append(generate_symbol_element("resistor", "62/0"))
    connectivity.append(generate_symbol_element("res_mk", "110/5"))
    connectivity.append(generate_symbol_element("cap_mk", "117/5"))

    connectivity.append(generate_symbol_element("poly", "30/0+30/10-resistor-res_mk"))
    connectivity.append(
        generate_symbol_element("metal1", metal_connectivity(34) + "-110/11")
    )
    connectivity.append(
        generate_symbol_element("metal2", metal_connectivity(36) + "-110/12")
    )
    connectivity.append(
        generate_symbol_element("metal3", metal_connectivity(42) + "-110/13")
    )
    connectivity.append(
        generate_symbol_element("metal4", metal_connectivity(46) + "-110/14")
    )
    connectivity.append(
        generate_symbol_element("metal5", metal_connectivity(81) + "-110/15")
    )
    connectivity.append(
        generate_symbol_element("metaltop", metal_connectivity(53) + "-110/16")
    )

    connectivity.append(generate_symbol_element("contact", "33/0"))
    connectivity.append(generate_symbol_element("via1", "35/0"))
    connectivity.append(generate_symbol_element("via2", "38/0"))
    connectivity.append(generate_symbol_element("via3", "40/0"))
    connectivity.append(generate_symbol_element("via4", "41/0-cap_mk"))
    connectivity.append(generate_symbol_element("via5", "82/0-cap_mk"))

    connectivity.append(generate_connection_element("poly", "contact", "metal1"))
    connectivity.append(generate_connection_element("metal1", "via1", "metal2"))
    connectivity.append(generate_connection_element("metal2", "via2", "metal3"))
    connectivity.append(generate_connection_element("metal3", "via3", "metal4"))
    connectivity.append(generate_connection_element("metal4", "via4", "metal5"))
    connectivity.append(generate_connection_element("metal5", "via5", "metaltop"))

    return connectivity


def update_tech_file_sky130A(report: Element):
    new_report = Element(report.tag)

    new_report.append(generate_text_element("name", "sky130A"))
    new_report.append(get_child_element(report, "description"))
    new_report.append(get_child_element(report, "group"))
    new_report.append(generate_text_element("dbu", "0.005"))
    new_report.append(get_child_element(report, "base-path"))
    new_report.append(get_child_element(report, "original-base-path"))
    new_report.append(get_child_element(report, "layer-properties_file"))
    new_report.append(get_child_element(report, "add-other-layers"))
    new_report.append(get_child_element(report, "reader-options"))
    new_report.append(get_child_element(report, "writer-options"))
    new_report.append(get_sky130_connectivity())

    return new_report


def update_tech_file_gf180mcuD(report: Element):
    new_report = Element(report.tag)

    new_report.append(generate_text_element("name", "gf180mcuD"))
    new_report.append(get_child_element(report, "description"))
    new_report.append(get_child_element(report, "group"))
    new_report.append(generate_text_element("dbu", "0.005"))
    new_report.append(get_child_element(report, "base-path"))
    new_report.append(get_child_element(report, "original-base-path"))
    new_report.append(get_child_element(report, "layer-properties_file"))
    new_report.append(get_child_element(report, "add-other-layers"))
    new_report.append(get_child_element(report, "reader-options"))
    new_report.append(get_child_element(report, "writer-options"))
    new_report.append(get_child_element(report, "d25"))
    new_report.append(get_gf180mcu_connectivity())

    return new_report


def main(tech_file: Path, pdk: str):
    etree = ET.parse(tech_file.resolve())

    if pdk == "sky130A":
        updated_tree = ET.ElementTree(update_tech_file_sky130A(etree.getroot()))

    elif pdk == "gf180mcuD":
        updated_tree = ET.ElementTree(update_tech_file_gf180mcuD(etree.getroot()))

    ET.indent(updated_tree, space=" ")
    connectivity_validation(updated_tree)

    updated_tech_file = Path(f"{tech_file.parent}/{tech_file.stem}.lyt")
    updated_tree.write(
        updated_tech_file.resolve(), encoding="utf-8", xml_declaration=True
    )

    print(updated_tech_file.resolve())

    return updated_tree


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Program that fix errors on klayout .lyt files",
        epilog="Should be run with root permisions",
    )

    parser.add_argument(
        "filename",
        help="Path to klayout tech file .lyt",
        type=str,
    )
    parser.add_argument(
        "--pdk",
        help="Specifies which modifications should be done according to pdk",
        type=str,
        choices=["gf180mcuD", "sky130A"],
        default="sky130A",
    )
    args = parser.parse_args()

    tech_file = Path(args.filename)

    if not tech_file.exists():
        print("lyrdb file doens't exists")
        exit(-1)

    main(tech_file, pdk=args.pdk)
