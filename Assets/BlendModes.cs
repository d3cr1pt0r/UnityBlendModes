using UnityEngine;
using UnityEngine.Rendering;
using System.Collections.Generic;

// See _ReadMe.txt for an overview
[ExecuteInEditMode]
public class BlendModes : MonoBehaviour
{
	public enum BlendMode
	{
		Normal, Additive, Multiply, Divide, Subtract, Overlay, Darken, Lighten, Difference, HardLight, Screen, ColorDodge, ColorBurn, LinearBurn
	}

	[SerializeField] private BlendMode blendMode = BlendMode.Normal;
	[SerializeField] private Camera cam = null;

	private CommandBuffer commandBuffer;
	private Renderer rend;
	private List<string> map;
	private BlendMode lastChosenMode;

	private void Cleanup()
	{
		if (commandBuffer != null && cam != null)
			cam.RemoveCommandBuffer (CameraEvent.AfterSkybox, commandBuffer);
	}

	public void Awake() {
		rend = GetComponent<Renderer> ();
		map = new List<string> ();
		lastChosenMode = BlendMode.Normal;

		map.Add ("_NORMAL");
		map.Add ("_ADDITIVE");
		map.Add ("_MULTIPLY");
		map.Add ("_DIVIDE");
		map.Add ("_SUBTRACT");
		map.Add ("_OVERLAY");
		map.Add ("_DARKEN");
		map.Add ("_LIGHTEN");
		map.Add ("_DIFFERENCE");
		map.Add ("_HARDLIGHT");
		map.Add ("_SCREEN");
		map.Add ("_COLORDODGE");
		map.Add ("_COLORBURN");
		map.Add ("_LINEARBURN");
	}

	public void OnEnable()
	{
		Cleanup();
	}

	public void OnDisable()
	{
		Cleanup();
	}

	public void Update() {
		if (lastChosenMode != blendMode) {
			lastChosenMode = blendMode;
			setBlendMode (lastChosenMode);
		}
	}

	private void setBlendMode(BlendMode blendMode) {
		if (rend == null)
			return;
		
		disableAllKeywords ();
		rend.material.EnableKeyword (map [(int)blendMode]);
	}

	private void disableAllKeywords() {
		for (int i = 0; i < map.Count; i++) {
			rend.material.DisableKeyword (map [i]);
		}
	}

	// Whenever any camera will render us, add a command buffer to do the work on it
	public void OnWillRenderObject()
	{
		bool active = gameObject.activeInHierarchy && enabled;

		if (!active) {
			Cleanup();
			return;
		}
		if (!cam || commandBuffer != null) {
			return;
		}

		commandBuffer = new CommandBuffer();
		commandBuffer.name = "BlendModes";

		int screenCopyID = Shader.PropertyToID("_ScreenCopyTexture");
		commandBuffer.GetTemporaryRT (screenCopyID, -1, -1, 0, FilterMode.Bilinear);
		commandBuffer.Blit (BuiltinRenderTextureType.CurrentActive, screenCopyID);

		commandBuffer.SetGlobalTexture("_GrabBlendTexture", screenCopyID);

		cam.AddCommandBuffer (CameraEvent.AfterSkybox, commandBuffer);
	}	
}
