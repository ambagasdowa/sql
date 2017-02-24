--Use sistemas

CREATE PROCEDURE sp_projections_log_lv9
(
	@data nvarchar(4000)
)
With Encryption
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON


	/*==========================================================================================================================================
	 Authors        : FullStackDeveloper JesusBaizabal (ProcedureProgramation&TableSquemaDesign and Core)
	 email          : baizabal.jesus@gmail.com and fcojaviergv@gmail.com
	 Create date    : Feb 17, 2017
	 Description    : sp_projections_log_lv9
	 @license       : MIT License 0(http://www.opensource.org/licenses/mit-license.php)
	 Database owner : Any
	 @status        : Stable
	 @version       : 1.0.0
	 ============================================================================================================================================*/
 
	 /*
	 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
	 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
	 IN THE SOFTWARE.
	 */

	-- ==========================================================================================================================================
	--	Log for Projections Software 
	-- ==========================================================================================================================================
	
	insert into sistemas.dbo.projections_systems_logs values ('system',@data,9,CURRENT_TIMESTAMP)

	END