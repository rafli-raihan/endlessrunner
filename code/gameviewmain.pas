{ Main view, where most of the application logic takes place.

  Feel free to use this code as a starting point for your own projects.
  This template code is in public domain, unlike most other CGE code which
  is covered by BSD or LGPL (see https://castle-engine.io/license). }
unit GameViewMain;

interface

uses Classes, castlekeysmouse, math,
  CastleScene, CastleTransform, CastleVectors, CastleCameras,
  CastleComponentSerialize, CastleUIControls, CastleControls,
  CastleViewport, CastleWindow, CastleApplicationProperties,
  CastleUtils, CastleLog;

type
  { Main view, where most of the application logic takes place. }
  TViewMain = class(TCastleView)
  published
    { Components designed using CGE editor.
      These fields will be automatically initialized at Start. }
    LabelFps: TCastleLabel;
    GameplayViewport: TCastleViewport;
    GroundGroup: TCastleTransform;
    Camera1: TCastleCamera;
    procedure UpdateGround;
  public
    GroundTiles: array of TCastleScene;
    TileWidth: Single;
    constructor Create(AOwner: TComponent); override;
    procedure Start; override;
    procedure Update(const SecondsPassed: Single; var HandleInput: Boolean); override;
    function Press(const Event: TInputPressRelease): Boolean; override;
  end;

var
  ViewMain: TViewMain;

implementation

uses SysUtils;

{ TViewMain ----------------------------------------------------------------- }

constructor TViewMain.Create(AOwner: TComponent);
begin
  inherited;
  DesignUrl := 'castle-data:/gameviewmain.castle-user-interface';
end;

procedure TViewMain.Start;
var
  I, TileCount: Integer;
  ViewWidth: Single;
  Tile: TCastleScene;
begin
  inherited;

  TileWidth := 128.0;

  ViewWidth := Camera1.Orthographic.Width;
  TileCount := Ceil(ViewWidth / TileWidth) + 2;

  SetLength(GroundTiles, TileCount);
  for I := 0 to TileCount - 1 do
  begin
    Tile := TCastleScene.Create(FreeAtStop);
    Tile.Load('castle-data:/assets/ground/ground.png');
    Tile.Translation := Vector3(I * TileWidth, 0, 3);
    GroundGroup.Add(Tile);
    GroundTiles[I] := Tile;
  end;
end;

procedure TViewMain.UpdateGround;
var
  I: Integer;
  CamX, StartX: Single;
begin
  CamX := Camera1.Translation.X;
  StartX := Floor(CamX / TileWidth) * TileWidth;

  for I := 0 to High(GroundTiles) do
  begin
    GroundTiles[I].Translation := Vector3(
      StartX + I * TileWidth,
      GroundTiles[I].Translation.Y,
      3
    );
  end;
end;

procedure TViewMain.Update(const SecondsPassed: Single; var HandleInput: Boolean);
begin
  inherited;
  { This virtual method is executed every frame (many times per second). }
  Assert(LabelFps <> nil, 'If you remove LabelFps from the design, remember to remove also the assignment "LabelFps.Caption := ..." from code');
  LabelFps.Caption := 'FPS: ' + Container.Fps.ToString;
  UpdateGround;
end;

function TViewMain.Press(const Event: TInputPressRelease): Boolean;
begin
  Result := inherited;
  if Result then Exit; // allow the ancestor to handle keys

  { This virtual method is executed when user presses
    a key, a mouse button, or touches a touch-screen.

    Note that each UI control has also events like OnPress and OnClick.
    These events can be used to handle the "press", if it should do something
    specific when used in that UI control.
    The TViewMain.Press method should be used to handle keys
    not handled in children controls.
  }

  // Use this to handle keys:
  {
  if Event.IsKey(keyXxx) then
  begin
    // DoSomething;
    Exit(true); // key was handled
  end;
  }
end;

end.
