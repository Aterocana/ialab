package xclipsjni;

/**Questa classe implementa un'eccezione specifica per le eccezioni lanciate dall'ambiente di clips.
 *
 * @author Poivesan Luca, Verdoja Francesco
 * Edited by: @author  Violanti Luca, Varesano Marco, Busso Marco, Cotrino Roberto
 */
public class ClipsException extends Exception {

	private final String message;

	/**Crea una nuova eccezione da lanciare.
	 * 
	 * @param message il messaggio d'errore da allegare all'eccezione
	 */
	public ClipsException(String message) {
		this.message = message;
	}

	@Override
	public String toString() {
		return this.message;
	}

	@Override
	public String getMessage() {
		return this.message;
	}
}
