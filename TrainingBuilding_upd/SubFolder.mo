within TrainingBuilding_upd;
package SubFolder
  package Components
    model Model1
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end Model1;

    block ControlBlock
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end ControlBlock;

    record Record1
      parameter Real a1;
      parameter Real a2;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end Record1;
  end Components;
end SubFolder;
