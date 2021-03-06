import React from "react";
import { useTranslate, SelectArrayInput } from "react-admin";
import { InputProps } from "ra-core";

import segments from "../segments/data";

const SegmentsInput = ({ addField, ...rest }) => {
  const translate = useTranslate();
  return (
    <SelectArrayInput
      {...rest}
      choices={segments.map(segment => ({
        id: segment.id,
        name: translate(segment.name)
      }))}
    />
  );
};

SegmentsInput.defaultProps = {
  addField: true,
  source: "groups",
  resource: "customers"
};

export default SegmentsInput;
